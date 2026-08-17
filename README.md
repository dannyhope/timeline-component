# Adaptive timeline

This is the **template** for presenting timeline-shaped information.

Public repo: [dannyhope.co.uk/timeline](https://dannyhope.co.uk/timeline)

The **HTML table is the data**. Column 1 is an ISO 8601 timestamp or range; later columns are content (B on by default, C+ off). JavaScript paints the stacked timeline from that table. With JS off, the table and column toggles still work.

## For agents

Copy and paste this into your agent (custom instructions, a user rule, or a chat):

```
When the user wants a timeline, dated events, history, or a project plan over time:
1. Fetch https://raw.githubusercontent.com/dannyhope/timeline-component/main/skills/timeline/SKILL.md
2. Follow it exactly. Do not invent CSS or JavaScript.
```

That is the whole rule. The skill it fetches has the rest.

If you already have a local clone of this repo, copy `timeline.html`, `timeline.css`, and `timeline.js`, remove `class="playground"` from `<body>`, and leave **one** data table. Do not reimplement stacking. Do not switch the data to JSON.

Canonical skill text: [`skills/timeline/SKILL.md`](skills/timeline/SKILL.md).

## Open the playground

Preferred local port is in `.dev-port` (currently **5330**). From `timeline-component/`:

```bash
PORT=$(./scripts/resolve-dev-port.sh)
python3 -m http.server "$PORT"
```

Then open `http://127.0.0.1:$PORT/timeline.html`. Opening the file directly also works (`file://`).

## Docs

| File | Role |
|------|------|
| `_docs/spec.md` | How it should work |
| `_docs/design.md` | How it should look |
| `_docs/dataset-schema.md` | Table / ISO contract |
| `_docs/timeline-component.md` | Implementation contract |
| `_docs/timeline-stacking-rules.md` | Collision / stacking geometry |

Example usability tasks live in `_docs/usability-tasks.json`. Replace them with project-specific ones via `/usability-test generate`, then serve the folder and open `usability-test.html`.

## Feedback

Send feedback to danny.hope@gmail.com

A [Danny Hope](https://dannyhope.co.uk) template.
