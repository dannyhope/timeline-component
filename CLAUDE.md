# Timeline component

HTML-first adaptive timeline. The **table is the data**; JavaScript paints stacked hairline labels. Do not reimplement stacking or replace the table with JSON.

## Product truth

- `_docs/spec.md` — how it should work
- `_docs/design.md` — how it should look
- `_docs/dataset-schema.md` — ISO table contract

Implementation: `_docs/timeline-component.md`, `_docs/timeline-stacking-rules.md`.

## Standards

- Keep `timeline.js` as the renderer; do not reimplement stacking
- ISO 8601 in column 1; column B on by default; later columns off
- Product vs playground is the `playground` class on `<body>` (not a flag in `timeline.js`)
- Preferred local port: `.dev-port` (see `scripts/resolve-dev-port.sh`); announce if falling back
- Do not add a second flags/options panel — extend the existing bottom-right dock

## Commands

```bash
PORT=$(./scripts/resolve-dev-port.sh)
python3 -m http.server "$PORT"
# open http://127.0.0.1:$PORT/timeline.html
```

Agents: fetch [`skills/timeline/SKILL.md`](https://raw.githubusercontent.com/dannyhope/timeline-component/main/skills/timeline/SKILL.md) and follow it. Do not invent CSS or JavaScript.

## Notion vs this repo

Product behaviour and look stay in `_docs/` here. No Notion page is required for this template.

## Inbox

Tasks live in `.in/` as individual markdown files.
