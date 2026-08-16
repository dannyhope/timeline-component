# How to give this timeline to Grok

Paste **only** [`grok-prompt.md`](grok-prompt.md). It is short on purpose: CSS and JS live in the public repo, not in Grok’s rules.

Repo: https://github.com/dannyhope/timeline-component

## Grok Project (best)

1. On [grok.com](https://grok.com), open **Projects** and create one (e.g. “Timelines”).
2. Paste **[`grok-prompt.md`](grok-prompt.md)** into that project’s instructions.
3. Chat **inside that project**. Ask for a timeline.

Grok should emit one HTML file that **links** `timeline.css` and `timeline.js` from jsDelivr, with a new data table for the topic. It should not paste the renderer into the file.

If the download contains a homemade `<script>` instead of the jsDelivr URL, it guessed. Remind it: “Use grok-template.html from github.com/dannyhope/timeline-component. Link timeline.js from jsDelivr. Only change the table.”

## One-off chat

Paste the whole of [`grok-prompt.md`](grok-prompt.md), then ask.

## Every Grok chat

Custom instructions can be the contents of [`grok-prompt.md`](grok-prompt.md).
