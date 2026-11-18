---
name: timeline
description: Present chronological, historical, or project-timeline information using Danny's adaptive HTML timeline. Data is an HTML table (ISO time in column 1); JS enhances it into stacked hairline labels. Use when the user wants a timeline, a dated sequence, history, a project plan over time, or says "show this as a timeline".
---

# Timeline

This reusable timeline is **not** a markdown list, Mermaid Gantt, JSON blob, or a canvas. Emit **one HTML file** whose **table is the data**. JavaScript paints the timeline from that table; without JS the table still works (progressive enhancement).

**Repo:** https://github.com/dannyhope/timeline-component

By default, do not invent CSS or JavaScript, and do not rewrite stacking or collision logic. Make those changes only when Danny asks for them (for example sticky labels, skipping empty periods, or a better layout).

## Check GitHub comments

Before working on a timeline, check the repo for comments people have left: open issues, pull request comments and review comments, and commit comments (for example `gh issue list`, `gh pr list` and `gh api repos/dannyhope/timeline-component/comments`). Then:

1. Explain each comment in a sentence or two, in plain words: what it asks for and what it would change.
2. Ask Danny whether to implement it, one comment at a time, as a yes or no question.
3. Make only the changes he says yes to. If there are no comments, say so in one line and carry on.

## Ask first

Before building, ask the person who asked for the timeline these two questions (one short message, both at once). Skip a question only if they've already answered it.

1. **Range slider:** "Do you want a date slider so you can narrow the timeline to a range?" If yes, add a two-handle date-range slider above the views. It filters the rows shown in every view, instantly, with no transitions.
2. **Table view:** "Do you want a vertical table view as well, with a switch between it and the timeline?" If yes, show the timeline and the table as alternative views, one at a time, with a two-segment switch ("Timeline" | "Table", timeline selected by default). The selected segment must be unmistakably distinct. Switching is instant, segments are keyboard accessible (buttons with `aria-pressed`, or a radio group) and show the pointer cursor. When switching back to the timeline, fire a `resize` so it measures itself. If no, keep the default: the table is the data source and the timeline replaces it when JS is on.

Don't use an expand/collapse toggle to hide either view.

When the timeline has a vertical or table view, keep the scale labels (year, month, and so on) position sticky, and offer a way to skip empty stretches of the scale. Label those stretches as a count, for example "4 days skipped".

## Remote agents (no local clone)

1. Fetch https://raw.githubusercontent.com/dannyhope/timeline-component/main/template.html
2. Copy it. Keep the jsDelivr `<link>` and `<script src>` unchanged:
   - `https://cdn.jsdelivr.net/gh/dannyhope/timeline-component@main/timeline.css`
   - `https://cdn.jsdelivr.net/gh/dannyhope/timeline-component@main/timeline.js`
3. Replace only the data table (caption, `data-origin` / `data-end` / `data-kind`, rows).
4. Keep `#timeline` and the hidden `#controls` fields — the script reads them even when they are hidden.

The only `<script src>` must be that jsDelivr `timeline.js` URL, unless Danny has asked for a layout or behaviour change that needs a local edit. If you write stacking code yourself from scratch, you dropped the renderer, so start again from the skeleton.

## Local agents (working copy of this repo)

1. Read `_docs/spec.md` and `_docs/dataset-schema.md`.
2. Copy `timeline.html`, `timeline.css`, and `timeline.js`. Do not rewrite `timeline.js` unless Danny asks for a layout or behaviour change.
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

## Records and dates

Merge things that happen at the same time into one record, shown as a short list. Use short human dates such as "6 Nov" (include the year only if it is not the current year). Put the time relative to the main event start (for example doors opening) in brackets, such as "T − 1 d".

## Before saving

Check the copy for redundant wording, and cut asides that only repeat the line they sit on. Check the wording against Danny's content style guide: https://app.notion.com/p/dannyhope/Danny-Hope-content-style-guide-3089c704b5738095bbc2fa33e60d4439

## Do not

- Dump events only as chat bullets
- Port to React/shadcn unless Danny asks
- Put the events in JSON instead of a table
- Rewrite collision logic from memory; if Danny asks for a layout change, edit the existing files rather than starting again
- Use markdown lists, Mermaid, or JSON as the primary view
