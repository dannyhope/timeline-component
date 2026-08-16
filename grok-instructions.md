# Grok: how to present a timeline

Use this whenever the user wants history, a project plan, a sequence of dated events, or says “show this as a timeline”.

The **table is the data**. The timeline is an enhancement of that table (progressive enhancement / Hijax). Do not invent a new visual language. Do not use a markdown bullet list or a Mermaid Gantt as the primary view.

## What to emit

One **self-contained HTML file** the user can open in a browser, with or without JavaScript.

1. Copy `timeline.html` from this repo. Keep stacking, hairlines, and the scale grid.
2. Set `PLAYGROUND = false`.
3. Put the topic in **one** `<table class="timeline-data">`:

```html
<section class="timeline-source" data-id="topic">
  <fieldset class="col-toggles">
    <legend>Columns</legend>
    <label><input type="checkbox" data-col="2" checked> Event</label>
    <label><input type="checkbox" data-col="3"> Detail</label>
  </fieldset>
  <table class="timeline-data" data-kind="calendar-days" data-origin="1962-10-12" data-end="1962-10-30">
    <caption>Title <span class="caption-sub">Scale in one line</span></caption>
    <thead>
      <tr><th>Time</th><th>Event</th><th>Detail</th></tr>
    </thead>
    <tbody>
      <tr id="e1">
        <td><time datetime="1962-10-14T07:30">1962-10-14T07:30</time></td>
        <td>What happened</td>
        <td>Optional extra (hidden until the Detail column is on).</td>
      </tr>
    </tbody>
  </table>
</section>
```

4. Column 1 is ISO 8601 (instant or `start/end`). Column 2 is on by default; later columns are off.
5. Follow `_docs/dataset-schema.md`. Hairlines sit at the centre of the known interval.
6. Default label attachment is **left** of the hairline.

## Attach to a Grok Project

Add this file, `timeline.html`, `_docs/dataset-schema.md`, and `_docs/spec.md`.

## Do not

- Reimplement collision stacking
- Replace the table with JSON
- Include the Flags developer dock on a published timeline
