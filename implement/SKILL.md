---
name: implement
description: Implement an app from SPEC.md, then review JS, CSS, and update the spec. Use after creating or updating a SPEC.md file.
---

# Implement Workflow

When the user invokes this skill, run four subagent tasks for the specified app directory.

## Required Input

The user must provide an app path (e.g., `balance`, `description`, or a full path).

## Workflow

Launch these tasks in sequence (implementation first, then reviews in parallel):

### Task 1: Implement

Implement the app according to its SPEC.md. Use the description app as a template for:
- HTML structure (index.html)
- CSS styling patterns (index.css) - CSS variables, dark theme, .box component
- JS patterns (index.js) - $.yuwakisa.[AppName] constructor pattern

### Tasks 2-4: Reviews (run in parallel after Task 1)

**Task 2: Review JS for clarity**
- Follow coding standards from .skills/coding/SKILL.md
- Look for redundant code, unclear naming, missing guard conditions
- Make edits to improve

**Task 3: Review and clean CSS**
- Compare against description/index.css reference
- Remove unused rules, redundant properties
- Ensure consistent variable usage

**Task 4: Update SPEC.md**
- Review implementation and update spec with any changes
- Follow specification skill guidelines
- Document features, error handling, UI details that emerged

## Example Usage

```
/implement balance
/implement prompter
```
