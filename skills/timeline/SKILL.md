---
name: timeline
description: Present chronological, historical, or project-timeline information using Danny's adaptive HTML timeline. Data is an HTML table (ISO time in column 1); JS enhances it into stacked hairline labels. Use when the user wants a timeline, a dated sequence, history, a project plan over time, or says "show this as a timeline".
---

# Timeline

Danny's reusable timeline is **not** a markdown list, Mermaid Gantt, JSON blob, or Cursor Canvas. Emit a self-contained HTML file whose **table is the data**. JavaScript paints the timeline from that table; without JS the table still works (progressive enhancement).

**Repo:** `/Users/dannyhope/Dropbox/Timeline component/timeline-component`

## Before writing HTML

Read `_docs/spec.md` and `_docs/dataset-schema.md`. Copy `timeline.html`. Do not reimplement stacking.

## Produce a product timeline

1. Copy `timeline.html`.
2. Set `PLAYGROUND = false`.
3. Leave **one** `<section class="timeline-source">` with:

- Column 1: `<time datetime="ISO">` — timestamp or `start/end` interval
- Column 2: primary text (checkbox on by default)
- Later columns: extra fields (checkboxes off by default)

4. ISO precision *is* the resolution. Hairlines sit at the interval centre.
5. Labels attach to the **left** of the hairline by default.
6. British English in user-visible copy.

## Playground vs product

| Playground (`PLAYGROUND = true`) | Product (`false`) |
|----------------------------------|-------------------|
| Demo tables, dataset radios, Flags dock | One table + column toggles; timeline if JS is on |

Column checkboxes are product UI. The Flags dock is not.

## Do not

- Dump events only as chat bullets
- Use Cursor Canvas
- Port to React/shadcn unless Danny asks
- Put the events in JSON instead of a table
- Rewrite collision logic from memory

Grok: same rules; see `grok-instructions.md`.
