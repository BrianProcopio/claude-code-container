---
name: plan-to-issues
description: Convert a plan into issue files — either from the current conversation (e.g., after Plan mode) or from an existing plan file on disk. Also saves conversation plans to ./plans/. Use when the user wants to create issues from a plan, save a plan and make tickets, or says things like "create issues from this plan", "turn this into work items", or "make issues from ./plans/feature.md".
---

# Plan to Issues

Take a plan — either from the current conversation (typically via Plan mode) or from an existing file on disk — and create issue files in `./issues/`. If the plan came from conversation, also save it to `./plans/`.

The user has already iterated on the plan with you, so the breakdown should be well-defined. Your job is to capture it faithfully as artifacts, not to re-negotiate the entire scope — but you should validate that each phase stands on its own before turning it into an issue.

## Process

### 1. Identify the plan

The plan can come from two places:

- **Conversation context** — the user just finished planning with you (e.g. in Plan mode) and the plan is already in the conversation.
- **A file on disk** — the user points to an existing plan file (e.g. `./plans/sales-report.md`). Read it from disk.

If neither is obvious, ask the user whether they want to use a plan from this conversation or point to a file.

Extract from the plan:

- Feature name
- Phases or steps (these become your issues)
- Acceptance criteria for each phase
- Any dependency ordering between phases
- Architectural decisions or context that issues should reference
- User stories — derive these from the plan discussion using the format: `As a <actor>, I want a <feature>, so that <benefit>`

### 2. Save the plan

If the plan came from a file on disk, skip this step — it's already saved.

If the plan came from the conversation, create `./plans/` if it doesn't exist. Write the plan as a Markdown file named after the feature (e.g. `./plans/user-onboarding.md`).

Use this structure:

```markdown
# Plan: <Feature Name>

## User Stories

A numbered list of user stories derived from the plan. Each user story should be in the format of:

1. As a <actor>, I want a <feature>, so that <benefit>

This list should be extensive and cover all aspects of the feature discussed during planning.

---

## Phase 1: <Title>

### What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

### Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

---

<!-- Repeat for each phase -->
```

Adapt the template to fit the plan you actually discussed. If the plan included architectural decisions worth preserving (e.g. schema changes, API contracts), add an "Architectural decisions" section — but don't force one for smaller features where it would be empty. If there are no user stories to derive, leave that section out rather than inventing content.

### 3. Validate phases

Accept the plan phases as-is by default — the user already refined them during planning. But before creating issues, check each phase against these rules:

- Each phase should leave the application in a working state once completed. If completing Phase 1 would break the app until Phase 2 lands, that's a problem.
- Each phase should be independently demoable or verifiable.
- No phase should bundle multiple unrelated deliverables.

If any phase fails these checks, flag only those specific phases and propose a re-slice. Don't redo the entire breakdown — just fix the problematic phases. Present the proposed changes and get the user's approval before proceeding. If phases were re-sliced, update the saved plan file to reflect the changes so it stays in sync with the issues.

If all phases pass, move on without interrupting the user.

### 4. Create issue files

Derive a folder name from the feature (e.g. `./issues/user-onboarding/`). Create it if it doesn't exist.

For each phase in the plan, write a Markdown file named with a numeric prefix and slug (e.g. `01-setup-auth.md`, `02-user-profile.md`). Create files in dependency order so blockers come first.

Each plan phase typically maps to one issue. If a phase is clearly too large (multiple independent deliverables bundled together), split it — but this should be rare since the plan was already refined during the planning session.

Use this template for each issue:

```markdown
# <Issue Title>

## Parent plan

`<path-to-saved-plan-file>`

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation. Reference the parent plan rather than duplicating content.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- `<issue-filename>` (if any)

Or "None - can start immediately" if no blockers.

## User stories addressed

Reference by number from the parent plan:

- User story 3
- User story 7
```

### 5. Summarize

Tell the user:

- Where the plan was saved
- How many issues were created and where
- Which issues can start immediately (no blockers)
