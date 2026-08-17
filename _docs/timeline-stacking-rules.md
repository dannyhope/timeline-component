# Timeline stacking rules

This file is the source of truth for the adaptive stacking behaviour in
`timeline.html`. It records the rules extracted from the
Grok transcript and the implementation decisions needed to keep the layout
readable while the timeline is resized.

## Core model

- Typography uses `system-ui` and the browser root text size (`1rem`). The
  component has no width-dependent or responsive font-size overrides.
- Controls are presented in a bordered options panel that is absolutely
  positioned on the page below the default timeline reservation. The timeline
  height may change freely; the panel does not move with it.
- Every event keeps its chronological horizontal position, calculated from
  `data-at`. That attribute already holds the *resolved* position — the centre of
  the interval the event is known to fall within — so stacking never sees raw
  values or resolutions.
- An event consists of a 1 px hairline and a label attached to that hairline.
- Labels are allowed to share the same horizontal level only when their
  rendered rectangles do not overlap.
- The label is always above the hairline and has a background plus a higher
  z-index, so a connector cannot visually obscure its text.
- The timeline may become taller as labels stack. Vertical space is preferred
  over horizontal distortion or overlapping text.

## Horizontal rules

- The timeline canvas fills its parent container and is never wider than that
  container. It is not full-bleed to the viewport. The controls stay in the
  same column.
- Full width mode (default) keeps the timeline equal to the parent's
  available width and updates on resize. With Full width off, the Timeline
  width slider sets a fixed scale; the wrapper may then scroll if that scale
  exceeds the container.
- Text attached to the right reserves space on the right of the axis. The
  hairlines occupy the remaining space.
- Text attached to the left mirrors that arrangement: the reserve is on the
  left and the hairlines occupy the remaining space.
- Label widths are measured from the rendered DOM, not guessed from title
  length.
- With descriptions enabled, each label wraps within the configured Text box
  width slider, capped at 95% of the parent container.
- The Text box width slider sets the maximum width of every label box in both
  display modes. Long text wraps inside that maximum; short text keeps a
  compact max-content box.
- Consecutive hairlines must remain at least 1 px apart when that still fits.
- Events resolving to the same position receive a small horizontal nudge before
  the minimum gap rule is applied. The comparison uses the resolved value, so two
  events known only to the same day still count as coincident, while one of them
  naming a clock time separates them.
- Product / Full width never exceed the parent. If the 1 px gap cannot fit,
  trailing hairlines share the axis end rather than overflowing or scrolling.
  The playground width slider may grow the canvas so the gap still fits; only
  then does the wrapper scroll.

## Stacking priority

The side on which text attaches determines the priority direction:

- **Text to the right:** process events from latest to earliest
  (right-to-left). Later events claim the rows nearest the axis first. Earlier
  events are pushed downward when they collide. This places longer hairlines on
  the left side of a dense cluster and prevents later connectors from cutting
  through earlier labels.
- **Text to the left:** process events from earliest to latest
  (left-to-right). Earlier events claim the rows nearest the axis first, and
  later events are pushed downward. This mirrors the right-attached layout.

This priority is a semantic rule, not an incidental consequence of DOM order.
The implementation must not rely on the order of the event elements in the
HTML.

## Stable resizing rule

The stacking result must not visibly flip when the width slider moves by a
small amount:

1. Keep the previous row assignment for each event when that row is still
   valid.
2. Resolve events in the attachment-side priority order.
3. An event may keep its previous row only if its current label rectangle does
   not overlap a row already claimed by a higher-priority event.
4. If the previous row is blocked, move the event down one row at a time until
   it is clear.
5. When an event has no previous assignment, begin at the row nearest the axis.
6. Do not move a higher-priority event to accommodate a lower-priority event.
7. Clear row assignments when the attachment side, descriptions, Text box
   width, or Periods placement changes, because the label geometry or base top
   has changed.

This preserves the intended order during interactive resizing while still
allowing the layout to compact when a row is genuinely no longer needed.

## Vertical geometry

- The first row starts at `BASE_TOP` below the axis, plus the measured period
  band height when Periods is set to In events area.
- Each subsequent row is separated by a fixed 10px text margin plus the stack
  step.
- Collision tests use the actual selected label width and rendered height after
  wrapping has been applied.
- The hairline reaches the bottom edge of its associated label. It is rendered
  behind the label, so the label background hides the portion underneath the
  box while the connector visibly joins the box at its bottom.
- Timeline height is the bottom of the lowest label plus bottom padding. The
  options panel is out of document flow, so that height change does not move it.
- Changing Dataset rebuilds event nodes and clears stacking memory.
- The scale grid is rebuilt on every layout pass: one DOM row per unit level,
  cells absolutely positioned by start/end fraction, vertical borders as
  dividers. With Periods In scale, `--scale-height` is updated from the row
  count; with In events area it is zero and the band height offsets label
  stacking; with Hidden the grid is empty and height is zero.
- Finest numeric row density uses `SCALE_NUMBER_STEPS` (linear) or decade
  strides (log). Cells that cannot fit their label are packed away or left
  blank while dividers remain.
- Event horizontal position is a 0–1 fraction from the active scale kind
  (calendar days, linear units, or log seconds), taken from the resolved
  interval-centre value rather than the event's stored start value.

## Recalculation triggers

The complete measure → position → width → stack → axis pass runs after:

- changing visible table columns;
- changing text attachment side;
- toggling Full width;
- moving the timeline-width slider;
- moving the Text box width slider;
- changing Periods placement;
- resizing the timeline wrapper (especially while Full width is on);
- initial page load.

The pass must be deterministic for the same control values and must not use
timeouts or random ordering.

