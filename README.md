# Adaptive timeline

This is the **template** for presenting timeline-shaped information — on a website, in Grok, or in Cursor.

Public repo: [github.com/dannyhope/timeline-component](https://github.com/dannyhope/timeline-component)

The **HTML table is the data**. Column 1 is an ISO 8601 timestamp or range; later columns are content (B on by default, C+ off). JavaScript paints the stacked timeline from that table. With JS off, the table and column toggles still work.

## Open the playground

Preferred local port is in `.dev-port` (currently **5330**). From `timeline-component/`:

```bash
PORT=$(./scripts/resolve-dev-port.sh)
python3 -m http.server "$PORT"
```

Then open `http://127.0.0.1:$PORT/timeline.html`. Opening the file directly also works (`file://`).

## Reuse (agents)

1. Read `_docs/spec.md` and `_docs/dataset-schema.md`.
2. Copy `timeline.html`, `timeline.css`, and `timeline.js`.
3. Remove `class="playground"` from `<body>`.
4. Replace the data tables with **one** table for this topic (ISO in column 1).
5. Do not reimplement stacking. Do not switch the data to JSON.

Grok: paste [`grok-prompt.md`](grok-prompt.md) into Grok’s project instructions. It tells Grok to load CSS/JS from the public GitHub repo rather than pasting the renderer. How-to: [`grok-instructions.md`](grok-instructions.md).

Cursor: the personal **timeline** skill (`~/.cursor/skills/timeline` and `~/.claude/skills/timeline`). Canonical text: [`skills/timeline/SKILL.md`](skills/timeline/SKILL.md).

## Docs

| File | Role |
|------|------|
| `_docs/spec.md` | How it should work |
| `_docs/design.md` | How it should look |
| `_docs/dataset-schema.md` | Table / ISO contract |
| `_docs/timeline-component.md` | Implementation contract |
| `_docs/timeline-stacking-rules.md` | Collision / stacking geometry |

`from-grok/` is an archive of numbered HTML iterations, not the live template.

Example usability tasks live in `_docs/usability-tasks.json`. Replace them with project-specific ones via `/usability-test generate`, then serve the folder and open `usability-test.html`.

## Feedback

Send feedback to danny.hope@gmail.com

A [Danny Hope](https://dannyhope.co.uk) product.
