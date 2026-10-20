# PharKeep brand and component standards

This reference expands the short instructions in `SKILL.md`. The goal is predictable pharmacy operations UI, not decorative redesign.

## Design language

Keep surfaces white on `#F7F9FC`. Use dark text, thin borders, a consistent 8px/12px radius system, and only subtle elevations. Use PharKeep blue as the signature interaction color. Avoid green/teal as the default action color because the logo is blue.

## Interaction states

| Component | Default | Hover | Focus | Disabled |
|---|---|---|---|---|
| Primary button | `#0965CF`, white text | `#0757B5` | 2px brand outline | reduced prominence; retain readable label |
| Outline button | white, border `#DCE3ED` | soft blue tint | 2px brand outline | muted; no activation |
| Tabs | neutral text, transparent surface | neutral hover | visible outline | n/a |
| Selected tab | `#EAF3FF`, `#0965CF` text | slightly deeper tint | visible outline | n/a |
| Input/select | white, light border | light border change | blue outline, accessible error text when relevant | visible disabled state |
| Badge | semantics-driven | n/a | n/a | text remains meaningful |

## Semantic status palette

- Draft: neutral gray with visible 'Draft' label.
- Pending review: warm amber with text, not amber alone.
- Approved or scheduled: green with a corresponding textual label.
- Failed or blocked: red with a direct explanation and recovery action.
- Current/active date or selected view: light blue, not green.

Do not map clinical meaning to a new color without owner confirmation. Existing schedule codes can have payroll implications.

## Information hierarchy patterns

**Application shell:** a stable top navigation, page title, optional breadcrumb, user control, and consistent spacing. User management and schedule-management pages should share one shell.

**Toolbar:** primary filters close to the data they affect. Keep date navigation in one logical group. Do not put critical filters in tooltips on desktop.

**Metric card:** one label, one numeric value, one short description. Use tabular digits. Do not use icon-only card meaning.

**Draft schedule card:** schedule identity and date range first, current state second, next action third. Keep secondary actions in an action menu when space is limited.

**Data tables:** stable labels, minimum column widths, legible cell values, keyboard navigability. Set the correct scroll region. Avoid ellipsis for small, critical schedule codes. Prefer inline tooltips for abbreviated codes, but not as the sole path to understanding them.

**Responsive behavior:** at >=1024px show the fuller operations view. Below that allow toolbars to wrap. On phones, prefer simple, vertical control groups and a focused schedule Day/Week view; do not silently hide controls.

## Typography system

Preferred Inter; existing Geist acceptable until a planned common font migration. Use weights 400/500/600. Make number columns tabular. Avoid 11px interactive button labels. Use content-appropriate line height, typically 1.45–1.6 in text and 1.2–1.3 in headings.

## Accessibility checks

- Primary interactive blue `#0965CF` offers safer white-text contrast than logo blue `#0F74EC`.
- Ensure text contrast meets WCAG AA: 4.5:1 for normal text, 3:1 for large text and nontext essential affordances.
- Provide labels, `aria-current` or equivalent selected semantics, descriptive button names, accessible table headings, keyboard focus, and an announced validation message.
- Do not rely only on color for approved, draft, or pending status.
- Avoid fixed overlays that obscure records.

## Reusable design variables

Use `templates/pharkeep-tokens.css` or map its variables to the existing Tailwind/shadcn UI theme. Do not replace an existing theme without reviewing all affected pages.
