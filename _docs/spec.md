# Timeline Component — Product Spec

> Living document. Update whenever behaviour changes. Last updated: 2026-08-17.
>
> **This file is the source of truth for how the timeline should work.**

## Purpose
This repo is the **template** for presenting timeline-shaped information — on a website, in a Grok conversation, or in Cursor. Agents copy `timeline.html` and swap the dataset; they do not invent a new layout.

## Surfaces

| Surface | Chrome |
|---------|--------|
| **Playground** (`body` has class `playground`) | Dataset switcher, Flags options dock, width sliders — developer-only |
| **Product** (agent output, site embed) | Title, subtitle, timeline (if JS), table + column toggles. `body` without class `playground`. No Flags dock, no dataset switcher |

Demo datasets are HTML tables in `timeline.html` (ISO time in column 1). The table contract is `_docs/dataset-schema.md`.

## Progressive enhancement
The HTML table is the source of truth and the no-JS interface (Hijax / unobtrusive JS: the page works as a document, script only *enhances* it). A tiny inline script adds `html.js`. Without JS the timeline canvas is hidden; radios still switch demo tables (CSS `:has()`), and column checkboxes still show or hide cells.

- **Column 1** is always an ISO 8601 timestamp or `start/end` interval.
- **Column 2** is on by default; later columns are off until checked.
- Visible content columns (2+) are what the timeline label shows once JS runs.

## Overview
An adaptive, responsive horizontal timeline component that handles dense event clusters by using vertical stacking of labels connected via hairlines to the main timeline axis. Designed for project timelines, historical events, or any time-based data with potential for close-proximity markers.

## Datasets (playground)

A **Dataset** control at the top of the playground switches demo content and scale kind:

| Dataset | Base resolution | Scale |
|---------|-----------------|-------|
| Cuban Missile Crisis | day | Linear calendar days |
| Product sprint | hour | Linear units |
| Human civilisation | year | Linear years |
| Earth history | Myr | Linear Myr since formation |
| Life of the Universe | order of magnitude | **Logarithmic** seconds |

The universe dataset places the Big Bang in the first Planck times, then uses log time so minutes, years, gigayears and a speculative deep-future Big Crunch remain visible on one axis.

## Core Requirements
- **Horizontal Timeline Axis**: Main time scale line with event markers at proportional positions (linear or log, per dataset).
- **Centre of the known interval**: An event's stored value names an *interval*, not an instant — the interval being whatever resolution is actually known about it. The hairline sits at the **centre** of that interval, because the true instant inside it is unknown. Stating a finer resolution narrows the interval and moves the hairline. This applies on every scale kind, not just calendar days:
  - told a day only → midday, not the start of the day;
  - told 18:00 on a day → about three-quarters across that day;
  - told one minute → the 30-second mark of that minute;
  - told "1966" → the middle of 1966, not 1 January 1966;
  - told an order of magnitude on the log scale → the geometric middle of that decade.

  An interval that would run past either end of the axis is truncated at the axis bound, since nothing is known beyond what is shown. A resolution of `exact` gives a zero-width interval, and the value is used unchanged.
- **Event Markers**: Vertical hairlines dropping from markers to text labels.
- **Label Behavior**:
  - Text always positioned to the left of its hairline by default (right is configurable).
  - Labels hug content (width: max-content).
  - Variable widths: Labels can expand where space allows between hairlines.
- **Stacking Logic**:
  - Dynamic collision detection: Labels placed as high as possible, pushed down in steps if overlapping.
  - Right-to-left placement for right-attached text (longer hairlines on left of clusters).
  - Inverted for left-attached.
  - Progressive vertical offsets.
- **Scale grid (above the axis)**:
  - Hierarchical rows — one row per unit level (year / month / day, era / tick, …).
  - Vertical dividers at cell boundaries spanning the grid; horizontal rules between rows.
  - Unit labels left-aligned inside their cells; a unit is not repeated on finer rows.
  - Finest numeric row chosen automatically: the densest resolution whose labels
    all fit their cells at the current width.
  - Cells too narrow for text keep their dividers; labels pack to what fits.
  - Summary cell only when no coarser rows can be shown.
- **Responsiveness**:
  - By default the timeline **fills its parent container and is never wider**. Product embeds (Grok, a site column, a chat artifact) must not grow a horizontal scrollbar.
  - Maintains ≥1px gap between hairlines when that still fits in the container. If the container is too narrow, trailing hairlines share the axis end rather than overflowing.
  - Scale and event layout both recompute from usable axis width.
  - Playground only: the Timeline width slider may make the canvas wider than the container; the wrapper then scrolls. That is a developer override, not the product default.
- **Controls** (playground only — not on product timelines):
  - Dataset radios (top of page).
  - Timeline width slider.
  - Full width toggle (default on: fill the parent container, never wider).
  - Text attachment side (left/right; defaults to left).
  - Max label width slider (capped at 95% of the parent container).
  - Extend into text space toggle (default off).
  - Periods placement: In scale (default), In events area, or Hidden.
  - Minimise button. The options panel is docked to the bottom-right of the
    viewport; collapsing it animates the panel into a round **Flags** button in
    the same corner, and pressing that animates it back. Focus follows the
    control that replaces the one pressed. The choice persists across reloads.

## Data Structure
Each dataset is an HTML table. Column 1 is time (ISO). Later columns are content. Scale bounds live on the `<table>` as `data-*` attributes. See `_docs/dataset-schema.md`.

ISO precision states the known interval (a date is a day; a clock time is a minute). An explicit `start/end` interval is centred on the hairline. `data-resolution="exact"` is a zero-width instant. Named resolutions (`century`, `order`, …) remain available on `<time>` when ISO cannot say it.

### Resolution (when not taken from ISO)
`resolution` states how wide that interval is. It is always declared, never inferred from whether a value happens to look round — a genuinely exact value must be able to say so.

| `resolution` | Interval |
|--------------|----------|
| omitted | one `baseResolution` of the scale (see below) |
| `'exact'` | zero width; the value is used unchanged |
| `'second'`, `'minute'`, `'hour'`, `'day'`, `'week'`, `'month'`, `'year'`, `'decade'`, `'century'`, `'millennium'`, `'myr'`, `'10myr'`, `'100myr'`, `'gyr'` | that duration, converted into the axis's own units |
| `'order'`, `'3orders'` | multiplicative: ×10 or ×1000, for logarithmic axes |
| a number | that many axis units |

Named durations are stored in seconds once and divided by the axis's seconds-per-unit, so `'century'` is 100 units on a year axis and 0.0001 units on a Myr axis without any per-scale tables.

### Scale descriptor additions
- `baseResolution` — the resolution assumed when an event does not state one. `day` for the calendar scale, the scale's own unit for linear scales, `order` for the log scale. Declared per dataset rather than derived from `unit`, so the default is visible where the scale is defined.
- `secondsPerUnit` — how many seconds one axis unit represents (`linear-units` only).

### `time` on calendar scales
On a `calendar-days` scale, a clock time in the ISO `datetime` (e.g. `T19:00`) is the start of the known interval. ISO precision is the resolution (minutes if `HH:MM` is given). `data-resolution` overrides that.

## Positioning on a logarithmic axis
Positions on the log scale map as `log(t / tMin) / log(tMax / tMin)`, so distance along the axis represents a *ratio*, not a difference. The centre of an interval is therefore its **geometric** midpoint, `sqrt(t0 × t1)` — the point that actually appears halfway across the rendered interval.

The arithmetic midpoint would be wrong here: for a one-decade interval it is `5.5 × t0`, which renders 74% of the way across the interval rather than 50%, visibly biased toward the late end. Since the whole rule is "the hairline sits at the centre of what is known", centre has to mean visually centred.

## Edge Cases
- Multiple events on same position (slight horizontal nudge). The nudge keys off the resolved position, so two day-only events on the same day are still treated as coincident.
- An event whose known interval overruns the axis end (the sprint's final hour, "now" on the civilisation scale): the interval is truncated at the bound, so the event sits exactly on the axis end rather than beyond it.
- Very dense clusters.
- Extreme narrow widths.
- Long vs short labels.
- Multi-month calendar ranges; multi-era log ranges.
- Dynamic range spanning ~10⁶⁰× (Planck → deep future) via log mapping.

## Tech
- HTML first. [`timeline.js`](../timeline.js) paints the timeline from the table. Do not rewrite that file to present a new topic.
- Styles live in [`timeline.css`](../timeline.css). Remote product pages load CSS and JS from the public GitHub repo via jsDelivr (see [`template.html`](../template.html)).
- Remote agents follow the public skill [`skills/timeline/SKILL.md`](../skills/timeline/SKILL.md).
- No JSON fetch required. The playground works over `file://`. Pages that load the CDN copies need a network.
- Column visibility is CSS `:has()` so it works with JS off.

Implementation contract: `_docs/timeline-component.md` and `_docs/timeline-stacking-rules.md`.
Table shape: `_docs/dataset-schema.md`.
