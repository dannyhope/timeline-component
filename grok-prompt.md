Whenever the user wants history, a project plan, dated events, or “show this as a timeline”, emit **one HTML file**.

Do not invent CSS or JavaScript. Load them from this public repo:

https://github.com/dannyhope/timeline-component

Exact URLs (copy unchanged):

- CSS: `https://cdn.jsdelivr.net/gh/dannyhope/timeline-component@main/timeline.css`
- JS: `https://cdn.jsdelivr.net/gh/dannyhope/timeline-component@main/timeline.js`
- Skeleton: https://raw.githubusercontent.com/dannyhope/timeline-component/main/grok-template.html

Fetch the skeleton if you can. Copy it. Replace only the data table (caption, `data-origin` / `data-end` / `data-kind`, rows). Keep `#timeline` and the hidden `#controls` fields — the script reads them even when they are hidden.

Rules:

- `body` must **not** have class `playground`
- One `.timeline-source`; column 1 = ISO 8601 (`datetime` or `start/end`); column 2 on; later columns off
- Do not use markdown lists, Mermaid, or JSON as the primary view
- The only `<script src>` must be the jsDelivr `timeline.js` URL above. If you write stacking or collision code yourself, you dropped the renderer — start again from the skeleton
