# Reference-page UI review (October 2026)

## Source identification

- `element (2).html`: Staff Schedule. Exported from a Teable-backed schedule page.
- `element (3).html`: Manage Schedules. Exported from the management route.
- `assets/pharkeep-logo-on-dark.png`: the supplied logo, used to sample the dominant blue.
- The HTML pages are **static exported markup**, not running Teable app code. Any runtime or permission change must be tested in the real app.

## Staff Schedule: observed

- Header includes UCI Infusion, Staff Schedule, application navigation, request controls, and schedule management.
- The schedule period selector appeared to show 'Choose a current or upcoming period' while a current schedule was displayed.
- Staff search, sections, employee filters, My schedule, Day, Week, 2 weeks, 4 weeks, date navigation, and legend are present.
- Default view shown in desktop review is 2 weeks.
- The table's visible grid cells displayed repeated `...` in reviewed rendering. Source includes numeric and letter codes; investigate whitespace/preformatted text, overflow and truncation.
- A floating 'Schedule requests' button overlaps the lower-right of the table.
- Small nav labels (around 11px in exported CSS) reduce readability.
- Main highlights and buttons currently use teal/green rather than PharKeep blue.

## Staff Schedule: preferred adjustment order

1. Recover actual schedule-cell text display. Examine `white-space`, indentation, inherited styles, widths and text overflow.
2. Correct the selected period label.
3. Put controls into clear groups and avoid grid overlap.
4. Provide responsive day/week view and a bounded scroll region.
5. Apply shared PharKeep color, type, focus, and size tokens.

## Manage Schedules: observed

- Header includes 'Manage schedules' and a separate 'Staff schedule' link.
- Primary actions are 'Create next schedule' and 'Upload Excel'.
- Four request summary cards: New requests, In review, Approved · Not scheduled, and Scheduled.
- Draft cards show schedule name, date range, saved status, request overlap, and buttons for Continue editing, Review & release, More.
- Further sections include Requests needing attention, Released schedules, Past schedules, and Staff & schedule settings.
- Status and action logic matter: an approved request is not necessarily applied to a schedule.
- Settings are described as saved per schedule version rather than globally.
- The page's desktop layout is readable but lacks the same application shell as the schedule page.
- Mobile review identified opportunities to constrain wide filter/select controls and button groups.

## Manage Schedules: preferred adjustment order

1. Use shared shell and component system.
2. Make task priority obvious and clarify the selected primary action per draft.
3. Shorten repetitive instructions without suppressing meaningful warnings.
4. Improve responsive controls and avoid overlays that cover action buttons.
5. Apply shared color, type, badge, and spacing tokens.

## Not assessed

This review does not verify server queries, row-level permissions, exported workbook correctness, live app event handlers, or workflow state transitions. Test them separately after design changes.
