# Dataset HTML table

> Living document. Last updated: 2026-08-16.
>
> The **table is the data**. JavaScript reads it to paint the timeline. Without
> JS, the table (and column toggles) are the whole interface.

## Shape

Each dataset is a `<section class="timeline-source">` containing:

1. A **Columns** fieldset of checkboxes (`data-col="2"` …)
2. Optional `<ol class="timeline-eras">` for log-scale era labels
3. `<table class="timeline-data">`

### Columns

| Column | Role | Default |
|--------|------|---------|
| A (1) | Time — ISO 8601 timestamp or `start/end` interval, in `<time datetime="…">` | Always visible |
| B (2) | Primary content (event title) | On |
| C+ | Extra content (detail, notes, …) | Off |

Toggles work **without JS** via CSS `:has()`. With JS, visible content columns become the timeline label (B = title; further on columns join as the description).

### `<table>` attributes

| Attribute | Meaning |
|-----------|---------|
| `data-kind` | `calendar-days` · `linear-units` · `log-seconds` |
| `data-origin` / `data-end` | Civil or hour-axis bounds (ISO) |
| `data-start` / `data-end` | Numeric axis bounds (`linear-units` years / Myr) |
| `data-unit` | `hour` · `year` · `Myr` |
| `data-base-resolution` | Fallback interval when a cell is not more precise |
| `data-period-label` | Coarse scale-row caption |
| `data-tick-format` | `round` · `yearCe` · `myrAgo` |
| `data-t-min` / `data-t-max` | Log axis, seconds |

`<caption>` is the title; `.caption-sub` is the subtitle.

### Column 1 (`<time>`)

Prefer ISO 8601 in both the `datetime` attribute and the cell text:

- Instant: `1962-10-14` or `1962-10-14T07:30`
- Interval: `1440/1450` or `1962-10-14T07:30/1962-10-14T08:30`

ISO precision **is** the resolution (a date is a day; `T07:30` is a minute). A `start/end` interval places the hairline at the centre of that span.

When civil ISO cannot name the axis (Myr, log seconds), set `data-at` (and optional `data-end-at`) on `<time>` in axis units. `data-resolution="exact"` still means a zero-width interval.

### Rows

`id` on `<tr>` is the event id. Remaining cells are content, switched with the column checkboxes.

## Agent output

1. Copy `timeline.html`, `timeline.css`, and `timeline.js` (or start from `template.html` and load CSS/JS from the public GitHub repo).
2. Remove `class="playground"` from `<body>`.
3. Leave one `.timeline-source` whose table is this topic.
4. Do not rewrite `timeline.js`. Do not replace the table with JSON.
