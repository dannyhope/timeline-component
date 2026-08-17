---
name: timeline
description: Present chronological, historical, or project-timeline information using Danny's adaptive HTML timeline. Data is an HTML table (ISO time in column 1); JS enhances it into stacked hairline labels. Use when the user wants a timeline, a dated sequence, history, a project plan over time, or says "show this as a timeline".
---

# Timeline

This reusable timeline is **not** a markdown list, Mermaid Gantt, JSON blob, or a canvas. Emit **one HTML file** whose **table is the data**. JavaScript paints the timeline from that table; without JS the table still works (progressive enhancement).

**Repo:** https://github.com/dannyhope/timeline-component

Do not invent CSS or JavaScript. Do not rewrite stacking or collision logic.

## Remote agents (no local clone)

1. Fetch https://raw.githubusercontent.com/dannyhope/timeline-component/main/template.html
2. Copy it. Keep the jsDelivr `<link>` and `<script src>` unchanged:
   - `https://cdn.jsdelivr.net/gh/dannyhope/timeline-component@main/timeline.css`
   - `https://cdn.jsdelivr.net/gh/dannyhope/timeline-component@main/timeline.js`
3. Replace only the data table (caption, `data-origin` / `data-end` / `data-kind`, rows).
4. Keep `#timeline` and the hidden `#controls` fields — the script reads them even when they are hidden.

The only `<script src>` must be that jsDelivr `timeline.js` URL. If you write stacking code yourself, you dropped the renderer — start again from the skeleton.

## Local agents (working copy of this repo)

1. Read `_docs/spec.md` and `_docs/dataset-schema.md`.
2. Copy `timeline.html`, `timeline.css`, and `timeline.js`. Do not rewrite `timeline.js`.
3. Remove `playground` from `<body>`.
4. Leave **one** `<section class="timeline-source">`.

## Table contract (every surface)

- Column 1: `<time datetime="ISO">` — timestamp or `start/end` interval
- Column 2: primary text (checkbox on by default)
- Later columns: extra fields (checkboxes off by default)
- ISO precision *is* the resolution. Hairlines sit at the interval centre.
- Labels attach to the **left** of the hairline by default.
- `body` must **not** have class `playground`
- British English in user-visible copy

## Playground vs product page

| Playground (`body.playground`) | Product page (no that class) |
|----------------------------------|-------------------|
| Demo tables, dataset radios, Flags dock | One table + column toggles; timeline if JS is on |

Column checkboxes are product-page UI. The Flags dock is not.

## Do not

- Dump events only as chat bullets
- Port to React/shadcn unless Danny asks
- Put the events in JSON instead of a table
- Rewrite collision logic from memory
- Use markdown lists, Mermaid, or JSON as the primary view
