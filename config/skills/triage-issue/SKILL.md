---
name: triage-issue
description: Triage a bug or issue by exploring the codebase to find root cause, then create a markdown issue file with a fix plan. Use when user reports a bug, wants to file an issue, mentions "triage", or wants to investigate and plan a fix for a problem.
---

# Triage Issue

Investigate a reported problem, find its root cause, and create a markdown issue file with a fix plan. This is a mostly hands-off workflow - minimize questions to the user.

## Process

### 1. Capture the problem

Get a brief description of the issue from the user. If they haven't provided one, ask ONE question: "What's the problem you're seeing?"

Do NOT ask follow-up questions yet. Start investigating immediately.

### 2. Explore and diagnose

Use the Agent tool with subagent_type=Explore to deeply investigate the codebase. Your goal is to find:

- **Where** the bug manifests (entry points, UI, API responses)
- **What** code path is involved (trace the flow)
- **Why** it fails (the root cause, not just the symptom)
- **What** related code exists (similar patterns, tests, adjacent modules)

Look at:

- Related source files and their dependencies
- Existing tests (what's tested, what's missing)
- Recent changes to affected files (`git log` on relevant files)
- Error handling in the code path
- Similar patterns elsewhere in the codebase that work correctly

### 3. Identify the fix approach

Based on your investigation, determine:

- The minimal change needed to fix the root cause
- Which modules/interfaces are affected
- What behaviors need to be verified
- Whether this is a regression, missing feature, or design flaw

### 4. Design fix plan

Create a concrete, ordered list of steps to fix the issue. Each step should be a vertical slice:

- Describe the specific behavior to fix or implement
- Describe the minimal code change needed

Rules:

- One change at a time, vertical slices
- Include a final refactor step if needed
- **Durability**: Only suggest fixes that would survive radical codebase changes. Describe behaviors and contracts, not internal structure. A good suggestion reads like a spec; a bad one reads like a diff.

### 5. Ask about testing plan

Before creating the issue file, ask the user: "Would you like me to include a testing plan with this issue?"

If yes, add a **Testing Plan** section to the issue that describes:

- What behaviors should be tested
- What types of tests are appropriate (unit, integration, e2e)
- Key scenarios and edge cases to cover

If no, skip the testing plan section and proceed to file creation.

### 6. Create the issue file

Create a markdown file in the `./issues/` directory. Use a descriptive, kebab-case filename based on the issue summary (e.g., `./issues/login-timeout-on-slow-connections.md`). Create the `./issues/` directory if it doesn't exist.

Do NOT ask the user to review before creating - just create it and share the file path.

<issue-template>

# [Issue Title]

## Problem

A clear description of the bug or issue, including:

- What happens (actual behavior)
- What should happen (expected behavior)
- How to reproduce (if applicable)

## Root Cause Analysis

Describe what you found during investigation:

- The code path involved
- Why the current code fails
- Any contributing factors

Do NOT include specific file paths, line numbers, or implementation details that couple to current code layout. Describe modules, behaviors, and contracts instead. The issue should remain useful even after major refactors.

## Fix Plan

A numbered list of steps:

1. [Describe the behavior to fix and the minimal change needed]
2. [Next behavior and change]
   ...

**REFACTOR**: [Any cleanup needed after all changes are made]

## Testing Plan (if requested)

- What behaviors should be tested
- Suggested test types and scenarios
- Key edge cases to cover

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Existing tests still pass

</issue-template>

After creating the file, print the file path and a one-line summary of the root cause.
