# PharKeep UI quality checklist

## Readability and hierarchy
- [ ] Page title, current context, and primary action are visible.
- [ ] Labels are concise and unambiguous.
- [ ] Schedule codes and numeric cells display their full critical values.
- [ ] Dates, totals, and request states can be scanned quickly.

## Brand
- [ ] Interactive accents use PharKeep blue tokens; statuses keep semantic colors.
- [ ] Logo displays with correct aspect ratio and contrast.
- [ ] Font family, weights, radii, and borders match the common UI system.
- [ ] No stray teal used as a decorative or primary-interaction color.

## Controls
- [ ] Buttons and fields use consistent heights and state styling.
- [ ] Primary actions match current workflow state.
- [ ] Focus ring is visible with a keyboard.
- [ ] All status meaning is available in text, not just color.
- [ ] Tooltips are not the only source of critical information.

## Responsive
- [ ] At 1440px desktop: table and filters are legible without clipping.
- [ ] At 768px tablet: groups wrap in sensible order.
- [ ] At 390px mobile: no page-wide horizontal overflow.
- [ ] Wide tables scroll *within* a table region; identity column remains identifiable.
- [ ] Fixed or floating controls do not hide cell values or buttons.

## Workflow safety
- [ ] Teable base, data links, roles, and access restrictions are unchanged unless explicitly requested.
- [ ] Approval, scheduling, and release remain distinct operations.
- [ ] Staff/hour-code/pay-period/FTE settings remain version-specific when they currently are.
- [ ] Existing schedule codes, filter behavior, and download/upload actions are preserved.
- [ ] Real Teable app tested for interaction; static export does not count as live test.

## Release summary
Report changes, tested viewport sizes, outstanding validation, and items needing approval.
