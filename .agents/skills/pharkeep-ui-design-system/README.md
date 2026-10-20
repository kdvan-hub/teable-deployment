# PharKeep UI Design System Skill

Version 1.0 — October 2026

Reusable styling and UI review rules for PharKeep applications in a self-hosted Teable Business environment.

## Contents

- `SKILL.md` — complete reusable skill. Use this first.
- `references/` — brand/component patterns, review findings, release checks.
- `templates/` — CSS/JSON tokens. Map to your live app theme.
- `assets/` — original user-provided logo for dark backgrounds.
- `prompts/TEABLE_BASE_MEMORY.txt` — memory prompt for Teable AI Chat in a Base.
- `prompts/TEABLE_APP_BUILDER.txt` — prompt to start or update an App Builder project.
- `AGENTS.md` — optional agent instructions for a project repository.

## Install and use in Teable

### A. Create a reusable AI Chat skill

1. Open the intended Teable Base and start AI Chat.
2. Open the Skill Creator feature (or ask Teable AI to use Skill Creator).
3. Provide `SKILL.md` as the skill content. Include the reference files if your version supports bundled files. If your version offers a skill ZIP import, use the included ZIP instead.
4. Name it `pharkeep-ui-design-system`. Keep the description from the YAML frontmatter.
5. In AI Chat, try `/pharkeep-ui-design-system` and request a review of a page.

Teable announced custom Skills for AI Chat and a slash command. It has not been verified here that your specific App Builder session automatically loads AI Chat skills, or that your version supports ZIP import.

### B. Store memory for the Base

1. In Teable AI Chat inside the correct Base, paste `prompts/TEABLE_BASE_MEMORY.txt`.
2. Ask it to confirm which guidance it saved. Test in a new AI Chat conversation in the same Base.
3. Repeat for each Base that needs the standards; Teable describes memory as Base-scoped.

### C. Apply rules in Teable App Builder

1. Open the application in App Builder.
2. Paste `prompts/TEABLE_APP_BUILDER.txt` into the application brief or development chat.
3. If the App Builder can read project files, provide `SKILL.md` and templates. If you manage the source code, store `AGENTS.md` and the skill in that repository.
4. Ask the builder to audit the app before changing implementation.
5. Test deployed desktop and mobile UI and verify all role-based operations.

### D. Update the rules later

Update `SKILL.md`, tokens, and the relevant reference. Reapply the skill to each tool where it was installed or copied. A downloaded ZIP does not automatically sync updates to Teable.

## Sources for platform support

- Skills in AI Chat: https://teable.ai/blog/skills-are-now-available
- Base-scoped memory: https://teable.ai/blog/ai-memory-and-file-downloads

## Safety notes

The review files are static HTML exports, not authoritative live source files. Avoid replacing live Teable app behavior with exported markup. Do not include patient information, credentials, or Teable access tokens in prompts or skill bundles.
