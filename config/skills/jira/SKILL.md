---
name: jira
description: "Write well-structured JIRA tickets from short descriptions. Produces a concise, searchable summary line and a structured description optimized for claude-code to generate implementation plans. Use this skill whenever the user wants to create, write, draft, or format a JIRA ticket, story, task, bug report, or epic. Also trigger when the user says things like 'write a ticket for...', 'create a story for...', 'I need a JIRA for...', or describes work they want to track and asks for a ticket."
---

# JIRA Ticket Writer

You write JIRA tickets that serve two audiences: humans searching and triaging in JIRA, and claude-code generating implementation plans from the description.

## How it works

The user gives you a short description of what they need. You produce:

1. **Summary** - A single line, max ~80 characters
2. **Description** - A structured breakdown that claude-code can directly consume as a task specification

## Writing the Summary

The summary is the first thing people see in boards, backlogs, and search results. It needs to work hard in a small space.

**Principles:**
- Lead with the action verb or component area (makes scanning a list fast)
- Include the key domain noun so it's findable (e.g., "lease schedule", "commission plan", "credit workflow")
- Skip filler words like "Implement the ability to" — just say "Add ..." or "Fix ..."
- Be specific enough to distinguish from similar tickets

**Pattern:** `[Action] [what] [where/when context if needed]`

**Examples:**
- Input: "we need to add a way to export lease schedules to CSV"
  Summary: `Add CSV export for lease schedules`

- Input: "the commission calculation is wrong when there are multiple plan transactions in the same period"
  Summary: `Fix commission calc for overlapping plan transactions in same period`

- Input: "users should be able to filter the opportunity list by credit status"
  Summary: `Add credit status filter to opportunity list`

## Writing the Description

The description uses a consistent structure so claude-code can parse it predictably and generate an implementation plan. Not every section is needed for every ticket — use your judgment about which sections apply.

### Template

```
## Context
[1-3 sentences explaining the business motivation and current state. Why does this matter? What exists today that's insufficient?]

## Requirements
- [Concrete, specific requirement — what the system should do]
- [Each requirement should be independently verifiable]
- [Use domain-specific terms accurately]

## Acceptance Criteria
- [ ] [Testable condition that proves the requirement is met]
- [ ] [Written as checkboxes so they can be ticked off during review]
- [ ] [Include edge cases and boundary conditions worth testing]

## Technical Notes
- [Implementation hints, relevant file paths, architectural constraints]
- [Known dependencies or integration points]
- [Performance considerations, migration needs, etc.]
```

### Section-by-section guidance

**Context** grounds the reader. A developer picking this up cold should understand the "why" in 10 seconds. Reference the business domain (e.g., "During lease origination, users need to...") rather than jumping straight to technical details. If there's a current workaround or a related past change, mention it briefly.

**Requirements** are the "what". Each bullet should describe observable behavior, not implementation steps. Think about what a test would assert. Avoid vague language like "improve" or "enhance" — instead say exactly what should change. If requirements span multiple areas (UI, API, data), group them with sub-bullets or labels.

**Acceptance Criteria** bridge requirements and QA. These are the specific scenarios someone would walk through to verify the ticket is done. Include the happy path and at least one edge case. Format as checkboxes so reviewers can track progress.

**Technical Notes** are optional but valuable when the codebase has non-obvious patterns. This is where you mention things like:
- Relevant existing code paths or services
- Database/migration implications
- API contract changes
- Constraints the implementer should know about

If you know the codebase (e.g., from project context or CLAUDE.md), reference specific paths, bundles, or patterns. If you don't, keep this section general or omit it.

## Ticket types

Adjust tone and structure by type:

- **Story/Feature**: Full template. Context explains user need, requirements describe new behavior.
- **Bug**: Context describes expected vs actual behavior and repro steps. Requirements describe the correct behavior. Technical Notes should include where the bug likely lives if known.
- **Task/Chore**: Context can be brief. Requirements list the work items. Acceptance criteria may be simpler.
- **Epic**: Context is broader (business initiative level). Requirements are high-level themes. Include a "## Suggested Breakdown" section listing potential child tickets.

## Output format

Present the ticket like this:

```
**Summary:** <the one-line summary>

**Type:** <Story | Bug | Task | Epic>

---

<the structured description in markdown>
```

If the user's input is ambiguous about the ticket type, default to Story and mention your assumption. If the description is too vague to write meaningful acceptance criteria, ask one clarifying question before proceeding — but only one, keep the friction low.
