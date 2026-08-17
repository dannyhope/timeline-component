# Adaptive timeline component specification

This document is the implementation contract for
`timeline.html`.

## Documentation maintenance contract

This document and `timeline-stacking-rules.md` are part of the component, not
historical notes. Any substantial change to the HTML, CSS, JavaScript, controls,
layout rules, typography, or responsive behaviour must update the relevant
documentation in the same change. A change is incomplete if the implementation
and these documents disagree.

When changing behaviour:

1. Update the relevant rule or control description here.
2. Update `timeline-stacking-rules.md` if the change affects geometry,
   collisions, ordering, connectors, or responsive layout.
3. Verify the browser states named in the change.
4. Record any new invariant or intentional exception.

Language models working on this component should read these documents before
editing the implementation and treat the current HTML plus these documents as
one maintained specification.

## Current structure

- `timeline.html` is the playground document: tables are the data; `timeline.css` styles it; `timeline.js` paints the timeline.
- Product pages start from `template.html` and load CSS/JS from the public GitHub repo.
- Demo datasets are `<table class="timeline-data">` sections in that file.
- Without JS the tables and column toggles remain usable (progressive enhancement).
- The timeline canvas fills its parent container (`.page` / the embed) and is
  not wider than that container. It does not break out to the viewport.
- The timeline height follows the stacked labels.
- In **playground** mode the options panel is fixed to the bottom-right of the
  viewport. In **product** mode (`body` without class `playground`) that dock is not shown.
- There is no footer commentary.

### Options dock

The panel and its collapsed **Flags** button occupy the same bottom-right corner
and share a bottom-right transform origin, so the two states scale and cross-fade
into one another over about 240ms. Minimise shrinks the panel away as the button
grows in; the button reverses it. Rules:

- Both states are toggled with the `dock-hidden` class, never the `hidden`
  attribute, so the transition can run; `visibility` keeps the inactive state out
  of the tab order.
- Transitions are gated behind `body.dock-animated`, added after the stored state
  has been applied, so a page that loads minimised does not animate on first paint.
- `prefers-reduced-motion: reduce` removes the transitions.
- The state persists in `localStorage` under `timeline.controlsMinimised`.
- Focus moves to whichever control replaces the one that was pressed.
- The dock is at most 46rem wide and wraps; each label, input and readout is
  grouped in a `.control` span so they never wrap apart.

## Controls

### Dataset

A select at the top of the page switches demo datasets. Each dataset supplies its
own title, subtitle, events, and scale kind:

- `calendar-days` — Cuban Missile Crisis
- `linear-units` — sprint (hours), civilisation (years), Earth (Myr)
- `log-seconds` — Life of the Universe (Planck time → deep future)

Changing dataset rebuilds the event DOM and clears stacking memory.

### Descriptions

The checkbox toggles the description sentence inside labels that have one.
Titles and dates remain present in both modes. The short `A` test event has no
description, so it remains deliberately minimal.

### Text attaches

- `left` (the default): labels extend to the left of their hairlines; the
  reserve sits on the left of the axis.
- `right`: labels extend to the right and the reserve/stacking direction mirrors.

### Full width

When checked (the default), the timeline fills its parent container and tracks
that container's size on resize. It is never wider than the parent, so the
page does not grow a horizontal scrollbar. The Timeline width slider is
disabled in this mode. Product timelines always behave this way.

### Timeline width

When Full width is off, the slider sets the timeline scale. Moving the slider
turns Full width off. The minimum is 320px, the maximum is 10000px, and that
maximum expands further to the available container width when needed. If the
chosen width exceeds the container, the wrapper scrolls — playground only.

### Text box width

The slider sets the maximum width of every event label, from 120px to 1000px. It
applies whether descriptions are enabled or not. Long text wraps inside the
selected maximum; short text keeps a compact max-content box. The effective
maximum is capped at 95% of the parent container.

### Scale numbers

There is no scale-numbers control. The finest numeric row picks its own
resolution: it tries day steps of 1, 2, 3, 6, then the whole span (decade strides
of 1, 2, 4, 8, 16 on the log scale) and keeps the first whose labels all fit their
cells. If none fit whole, it packs the labels that do; if none fit at all the row
is dropped.

Month names always sit on their own line above the day numbers and are not
repeated on each tick. The year is shown with the last month band.

### Periods

The Periods select places the hierarchical scale grid:

- `In scale` (default): above the axis; wrapper padding follows `--scale-height`.
- `In events area`: just under the axis inside the timeline. The band’s measured
  height is added to the label stack base so events occupy space below it rather
  than overlapping it.
- `Hidden`: no grid; `--scale-height` is zero.

Changing placement clears stacking memory, because the label base top changes.

### Text margin

There is no text-margin control. The vertical gap is fixed internally at 10px.

## Typography

- Use the system UI font: `system-ui, sans-serif`.
- Timeline text uses the browser root size, `1rem`.
- Normal timeline text uses weight 400.
- Synthetic font weights are disabled.
- The compressed date-range summary may use its intentional emphasis.
- Timeline width must not alter font size or font weight.

## Event positions

An event's stored `at` names the **start of an interval**, not an instant. The
interval is as wide as the resolution we actually know, and the hairline goes at
the centre of it, because the true instant inside it is unknown. Naming a finer
resolution narrows the interval and moves the hairline.

This is one rule for every scale kind. A day-only event sits at midday; a
minute-resolution event sits on that minute's 30-second mark; "1966" on a year
axis sits in the middle of 1966; 18:00 on a day sits about three-quarters across
it.

### Declaring resolution

`resolution` on an event is explicit and never inferred from whether a value
looks round, because inference cannot tell a genuinely exact value from a coarse
one:

- a named span — `exact`, `second`, `minute`, `hour`, `day`, `week`, `month`,
  `year`, `decade`, `century`, `millennium`, `myr`, `10myr`, `100myr`, `gyr`;
- `order` or `3orders` — multiplicative widths (×10, ×1000) for log axes;
- a number — that many axis units;
- omitted — the scale's `baseResolution`.

`RESOLUTIONS` holds each named span once, in seconds (or as a factor).
`axisUnitSeconds(scale)` gives the seconds in one axis unit — `DAY` for the
calendar scale, `scale.secondsPerUnit` for linear scales, `SEC` for log — so one
table serves every dataset. `exact` is a zero-width interval and resolves
unchanged.

On calendar scales `time` (`'HH:MM'` or hours) moves the interval start within
the day. Stating a clock time is itself a resolution claim, so `time` defaults
the resolution to `hour`, not to the scale's `day`; an explicit `resolution`
overrides that. Without this default, a day-wide interval starting at 19:00 would
resolve into the *following* day.

### Resolving

`resolveAt(data, scale)` returns the interval centre:

- `axisDomain(scale)` bounds the interval. Nothing is known beyond what is shown,
  so an interval overrunning either end is truncated there. This keeps the
  sprint's final hour and the civilisation scale's "now" on the axis end instead
  of past it, and removes any need to hand-mark boundary events as `exact`.
- Linear and calendar axes take the arithmetic centre, `(t0 + t1) / 2`.
- The log axis takes the **geometric** centre, `sqrt(t0 * t1)`. Distance along a
  log axis represents a ratio, so the geometric mean is the point that renders
  halfway across the interval. The arithmetic mean of a one-decade interval is
  `5.5 * t0`, which renders 74% of the way across it — visibly biased late — so
  arithmetic centring would contradict the rule it implements.

The resolved value is written to `data-at` when the dataset loads, so
`eventFraction`, the same-position nudge, stacking, and the scale grid all work
from it. Nothing downstream needs to know about resolutions.

## Responsive behaviour

- Events retain their proportional chronological positions.
- Labels stack vertically when their rectangles collide.
- Hairlines reach the bottom edge of their associated label.
- Scale is a hierarchical grid (Periods control: above the axis, in the events
  area, or hidden):
  - one row per unit level (e.g. year → month → day);
  - vertical lines divide cells and span the grid; horizontal lines separate rows;
  - labels are left-aligned in their cells;
  - the finest numeric row picks the densest resolution whose labels fit;
  - when in scale, `--scale-height` follows the row count so page chrome stays
    stable; when in the events area that height is reserved below the axis
    instead; when hidden it is zero.
- Universe positions use `log(t / tMin) / log(tMax / tMin)` so Planck-time
  events and gigayear-scale futures share one axis.
- The wrapper may scroll horizontally only when the playground width slider
  makes the canvas wider than the parent. Product / Full width never overflow.

## Verification checklist

After a significant change, check:

- default page load with Full width on: timeline equals the parent width, no
  horizontal scrollbar;
- Full width off, then timeline widths 320px, 600px, 900px, 1400px, and 10000px;
- resizing the container with Full width on keeps the timeline equal to it and
  still without a horizontal scrollbar;
- descriptions off and on;
- attachment right and left;
- Periods In scale, In events area, and Hidden;
- text box widths 120px and 1000px;
- the short `A` event produces a compact box;
- every dataset places its hairlines at the centre of each event's declared
  resolution: day-only events mid-cell, timed events at their hour within the
  cell, century-resolution events mid-century, and log-scale order-of-magnitude
  events at the geometric middle of their decade;
- `exact` events and events whose interval is truncated by the axis end sit on the
  bound, and nothing resolves outside the axis;
- scale month line plus day numbers across widths 320px, 600px, 900px, 1400px,
  and 10000px, with day numbers thinning out rather than colliding;
- no label overlaps;
- every hairline reaches its label bottom;
- the docked options panel stays in the bottom-right corner while the timeline
  width and description modes change;
- minimising and maximising animate between the panel and the Flags button in
  that corner, and a reload of the minimised state does not animate;
- no obsolete footer commentary or removed controls return.

