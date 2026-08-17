# Timeline Component — Design

> Living document. Update whenever visual design changes. Last updated: 2026-08-17.
>
> **This file is the source of truth for how the timeline should look.**

## Visual Design
- Main horizontal axis (thin line) with events stacked below.
- Event markers via vertical hairlines to labels.
- Labels: Boxes with background, blur, shadow, higher z-index.
- **Hierarchical scale grid** above the axis (year/month/day, era/tick, …).
- The timeline canvas fills the width of its parent (the page column or embed) and does not spill past it.
- Page header: title and short subtitle. Dataset radios are playground-only.
- Below the timeline: the data table (column 1 = ISO time) and column checkboxes. Column B on by default; later columns off.

## Product vs playground chrome
- **Product:** title, subtitle, timeline when JS is on, table + column toggles always. No developer dock.
- **Playground:** the same, plus dataset radios and a bottom-right Flags dock (width, attachment, periods). Column checkboxes are product UI, not Flags.

## Scale grid
Matches a nested calendar header:

- One **row per unit level** required by the dataset (e.g. year → month → day).
- **Vertical lines** at every cell boundary, spanning the full grid height.
- **Horizontal lines** between rows; outer box frames the grid.
- Labels are **left-aligned** inside their cell (small left padding).
- Light gray text (`#888`) and hairline borders (`#d0d0d0`).

### Alignment with events
A hairline sits at the centre of the interval its event is known to fall within, at whatever resolution that is. So an event known only to the day sits mid-cell rather than on the left divider, and never reads as belonging to the day before it; an event known to the hour sits at that hour inside the cell. The same holds on the year, Myr and logarithmic scales — a century-resolution event sits mid-century.

Sitting on a cell boundary is reserved for genuine precision: an `exact` value, or an interval truncated by the end of the axis. A hairline on a divider therefore means "this really is the boundary", not "we only know the cell".

On the logarithmic scale the centre is the geometric midpoint, so it looks centred in the rendered interval rather than pushed toward its late end.

### Rows by dataset
- Calendar: year row, month row, optional day-number row.
- Universe (log): era row, optional duration-tick row.
- Linear units: period caption row, optional numeric row.

### Extend into text space
- Off: the grid starts where the text band ends, leaving that band empty above the labels.
- On: the grid runs on into the text band, stopping short of the timeline edge only
  by as much as the leading label needs. Denser datasets extend less, because a wide
  label near the attachment edge holds the grid back.
- Cells stay aligned with their hairlines in both states — extending changes how much
  width the scale is mapped across, not the mapping itself.

### Periods placement
- **In scale** (default): the hierarchical period/scale grid sits above the axis
  and reserves height via `--scale-height` padding on the wrapper.
- **In events area**: the same grid sits just under the axis inside the timeline.
  It occupies vertical space there; event labels stack below the band rather than
  overlapping it. Hairlines still run from the axis to each label (the band paints
  over the mid-section).
- **Hidden**: the grid is not shown and no vertical space is reserved for it.

### Numeric row resolution
- Chosen automatically, never configured: the row shows the densest resolution
  (day steps of 1, 2, 3, 6, or whole span; decade strides of 1, 2, 4, 8, 16 on the
  log scale) whose labels all fit their cells.
- If no whole resolution fits, the row packs to the labels that do fit; cells and
  dividers remain where text is omitted.
- If nothing fits at all, the numeric row is dropped and coarser rows stand alone.

## Interactions
- Changing Dataset rebuilds events, title, subtitle, and scale rows.
- Relayout on resize and control changes; `--scale-height` tracks row count when
  Periods are In scale so the options panel stays put.

## Tokens / Styles
- Scale row height ~1.45rem.
- Cell label padding ~0.35rem.
- Hairline gap between events: min 1px.
- Options panel is a dock fixed 1.25rem from the bottom-right of the viewport,
  at most 46rem wide, wrapping onto several rows as needed. Each label, input
  and readout stays together on one line.
- Minimise button sits at the far right of the dock's last row.
- Collapsed state: 4rem round white **Flags** button in the same corner, same
  border and shadow as the dock.
- The two states share a bottom-right transform origin: minimising shrinks the
  dock into the corner as the button grows out of it (~240ms), and maximising
  reverses that. No animation on first paint; none under
  `prefers-reduced-motion: reduce`.

## Demo data
- Default playground dataset: Cuban Missile Crisis (calendar days).
- Universe: logarithmic seconds, Planck → speculative Big Crunch.
- Source: HTML tables in `timeline.html`.
