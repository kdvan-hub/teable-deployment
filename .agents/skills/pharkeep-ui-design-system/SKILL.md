---
name: pharkeep-ui-design-system
description: Apply PharKeep brand and UI/UX standards when designing, auditing, building, or changing any PharKeep web app, Teable App Builder interface, schedule, operations dashboard, staff-management page, table, form, or responsive component. Use this skill whenever the user requests changes to layout, colors, typography, spacing, accessibility, or component consistency in PharKeep products.
---

# PharKeep UI Design System

## Purpose

Create a consistent, calm, high-end, clinical, and product-led interface for PharKeep pharmacy operations software. Apply the rules below to new interfaces and to revisions of existing interfaces.

## Scope and environment

- Environment: Teable, self-hosted, Business license; applications may use Teable App Builder and Infra.
- Use the framework and styling system already in each app. Do not migrate frameworks unless the owner requests it.
- Respect Teable's data model, records, role-based permissions, schedule versions, and deployed infrastructure.
- Do not claim that this skill is automatically available to every App Builder project. Apply it where the project or agent has the instructions.
- Do not treat a visual redesign as permission to change business rules, database schema, auth, or workflows.

## Brand personality

- Clean, minimalist, professional, secure, measured, readable.
- Light-first interfaces. Prefer crisp white cards on a soft neutral page.
- Use only very subtle blue gradients, if any. Do not use heavy decoration, oversized shadows, or unrelated colors.
- Prioritize the operational task over decoration.
- Use pharmacist-friendly, precise, short UI labels. Do not use jargon when a clearer label exists.

## Color tokens (canonical)

| Role | Hex | Rule |
|---|---|---|
| Brand/logo blue | `#0F74EC` | Extracted approximate dominant blue from supplied logo. Use as non-text accent, icon, and identity color. |
| Interactive blue | `#0965CF` | Default for text-bearing primary buttons, active links, focus-visible affordances; white text. |
| Interactive hover | `#0757B5` | Hover for primary actions. |
| Accent blue light | `#EAF3FF` | Selected tabs, today's date, soft emphasis. |
| Page background | `#F7F9FC` | Main application canvas. |
| Surface | `#FFFFFF` | Cards, tables, panels, dropdowns. |
| Primary text | `#15181D` | Main copy and headings. |
| Muted text | `#667085` | Secondary text, labels, metadata. |
| Border | `#DCE3ED` | Light component borders. |
| Success bg/text | `#E9F7F0` / `#166B4B` | Completed or approved state, only when accurate. |
| Warning bg/text | `#FFF4D8` / `#925800` | Pending action or attention required. |
| Neutral bg/text | `#F1F4F8` / `#475467` | Draft, secondary, or inactive state. |
| Error bg/text | `#FDECEC` / `#B42318` | Errors, failures, or destructive actions. |

**Contrast rule:** Use `#0965CF` rather than the brighter logo blue for small white-on-blue labels. Verify contrast in the actual context. Do not rely on color alone for status.

**Legacy teal rule:** Replace legacy teal on generic primary buttons, active navigation, selection, and decorative accents with PharKeep blue. Retain teal/green when it communicates an actual successful state and semantic meaning would change if recolored.

## Logo rule

- The supplied asset `assets/pharkeep-logo-on-dark.png` contains white lettering. Use it on approved dark surfaces only.
- Do not put that white-lettered asset directly on a white or light surface.
- If a light-background logo is needed, request or locate the approved light version. Do not invent a new logo or stretch the artwork.
- Preserve aspect ratio and provide alternative text `PharKeep`.

## Typography

- Preferred typeface: Inter. Existing Geist implementations are acceptable. Choose one family per product, and use it consistently.
- Page heading: 26–28px, weight 600, line-height about 1.2–1.3.
- Section heading: 17–18px, weight 600.
- Card heading: 14–16px, weight 600.
- Body: 14px, weight 400, line-height about 1.5.
- Form label: 13–14px, weight 500.
- Secondary metadata: 12–13px. Never use very small text for an essential action.
- Buttons: 14px, weight 500.
- Tables: 12–14px depending on density. Critical schedule codes must remain legible.
- Use tabular numerals for dates, hours, counts, and KPI values where it helps comparison.

## Layout and spacing

- Use a 4px spacing base. Default gaps: 8, 12, 16, 24, and 32px.
- Main page padding: 12–16px on compact screens; 24px on desktop where space allows.
- Section gap: 24–32px. Card internal padding: 20–24px; compact cards may use 16px.
- Standard interactive control height: 40px. Use at least 44px for touch targets when possible.
- Control corner radius: 8px. Card radius: 12px. Status pill radius: full.
- Align controls to a common baseline. Do not mix 28px navigation targets with 40px form controls without a deliberate compact mode.
- Use borders more often than heavy shadows. Keep related filters in one group.

## Component behavior

- Provide Primary, Secondary, Ghost, Destructive, and Disabled button variants; use the Primary variant only for the page's main task.
- Use the same component tokens across pages for select, input, action menu, date picker, filter, badge, tab, toolbar, card, table, and dialog.
- Selected tabs use light-blue fill and dark-blue text. Current date uses a subtle blue treatment.
- Present status as a labeled badge, with a meaningful color and accessible text.
- Use visible focus indicators: at least a 2px contrasting outline with offset. Do not suppress keyboard focus.
- Provide informative empty, loading, and error states. Avoid blank panels and unlabeled spinners.
- Buttons must have meaningful accessible names; dialogs must trap focus and be dismissible.
- For desktop tables, use a sticky header and (when necessary) a sticky identity column. Do not freeze so many columns that data is hidden.
- On narrow screens, use scrolling within the data region or an appropriate day/week view. Avoid page-wide horizontal overflow.

## Staff Schedule: specific requirements

Source: user-provided `element (2).html` static export and visual review, October 2026.

1. Make scheduled values readable before changing visual styling. The review found schedule cell values appearing as `...` in the rendered export. Check whitespace, clipping, overflow, and text rendering. Do not silently replace or truncate values.
2. Display the selected schedule period, instead of a placeholder when a schedule is active.
3. Organize page controls as: title and main actions; schedule period; staff filters and view controls; date navigation; schedule table.
4. Keep the schedule grid dominant. Keep staff-name identity visible when horizontally scrolling.
5. Support Day, Week, 2 weeks, and 4 weeks when the existing app provides them. Prefer Day or Week on mobile; do not remove user options without approval.
6. Use a clear date header and a subdued today indicator.
7. Preserve schedule value meanings, leave codes, and legend. Explain codes near the grid; do not assign new meanings or colors without a code key.
8. Do not let floating request controls cover grid data, especially on mobile.
9. Preserve request time off/switch, My schedule, Filter staff, schedule selection, actions, and permissions.

## Manage Schedules: specific requirements

Source: user-provided `element (3).html` static export and visual review, October 2026.

1. Use the same header/navigation shell and control system as Staff Schedule.
2. Keep request-state summary cards. Make values easy to scan, with 14px labels and prominent tabular numbers.
3. Make the next task clear. Prioritize requests needing attention, drafts in progress, released schedules, and settings.
4. Present each draft with a short heading, date range, saved-state metadata, status, and a clear primary action.
5. Use 'Continue editing' as primary when editing is next; use 'Review & release' as primary only when the schedule is ready for that action.
6. Keep approval and release as distinct actions. Do not auto-release a schedule or auto-apply approved requests.
7. Condense repeated text when possible, but preserve warnings about approved requests that have not been incorporated.
8. Make filters and select controls responsive. No off-screen dropdowns or covered actions on mobile.
9. Preserve Create next schedule, Upload Excel, Past schedules, Staff & schedule settings, and existing permissions.
10. Existing staff/hour-code/pay-period/FTE settings are schedule-version-specific where the current app states this. Do not turn them into global settings without approval.

## Design task workflow

1. Inspect the target page or source. Identify the user task, access role, primary action, and information hierarchy.
2. Check current component tokens before adding new CSS. Reuse a shared component when possible.
3. Identify problems in this order: lost/hidden information; functional overlap or overflow; accessibility; hierarchy; spacing; branding; visual polish.
4. Propose minimal, reversible changes. Preserve routes, data bindings, labels with business meaning, state, and event behavior.
5. If editing, implement the changes in the source app. Do not use the static HTML export as proof that runtime behavior works.
6. Check desktop and mobile, keyboard navigation, light-mode contrast, and meaningful status states.
7. Report what changed, what remains untested, and where owner approval is needed.

## Supporting files

- `references/BRAND_AND_COMPONENTS.md`: component definitions and recommended patterns.
- `references/PAGE_REVIEW.md`: concrete issues from the two reference pages.
- `references/QUALITY_CHECKLIST.md`: acceptance criteria before release.
- `templates/pharkeep-tokens.css`: practical CSS tokens and primitive styles.
- `templates/pharkeep-tokens.json`: machine-readable design tokens.
- `prompts/TEABLE_BASE_MEMORY.txt`: instruction to save in Teable AI memory.
- `prompts/TEABLE_APP_BUILDER.txt`: app-specific initial prompt.

## Conflict policy

- Explicit new owner requests take priority over these defaults.
- Preserve business behavior, permissions, and accessible interactions over cosmetic changes.
- Ask before changing color-to-code meanings, underlying workflows, role visibility, or database operations.
- Do not claim all WCAG criteria are satisfied without testing.
