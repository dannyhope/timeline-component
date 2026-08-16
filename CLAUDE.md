# Timeline component

HTML-first adaptive timeline. The **table is the data**; JavaScript paints stacked hairline labels. Do not reimplement stacking or replace the table with JSON.

## Product truth

- `_docs/spec.md` — how it should work
- `_docs/design.md` — how it should look
- `_docs/dataset-schema.md` — ISO table contract

Implementation: `_docs/timeline-component.md`, `_docs/timeline-stacking-rules.md`.

## Standards

- Keep `timeline.html` as one document (markup + CSS + layout JS)
- ISO 8601 in column 1; column B on by default; later columns off
- `PLAYGROUND = true` for the demo Flags dock; product copies set it `false`
- Preferred local port: `.dev-port` (see `scripts/resolve-dev-port.sh`); announce if falling back
- Do not add a second flags/options panel — extend the existing bottom-right dock

## Commands

```bash
PORT=$(./scripts/resolve-dev-port.sh)
python3 -m http.server "$PORT"
# open http://127.0.0.1:$PORT/timeline.html
```

Usability runner: `usability-test.html` (needs the same local server so it can fetch `_docs/usability-tasks.json`). Replace the example tasks with `/usability-test generate`.

## Notion vs this repo

Product behaviour and look stay in `_docs/` here. No Notion page is required for this template.

## Inbox

Tasks live in `.in/` as individual markdown files.
