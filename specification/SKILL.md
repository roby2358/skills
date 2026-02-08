---
name: specification
description: Write and maintain SPEC.md technical specifications. Use when the user asks to create, update, or review a SPEC.md file, or when planning a new feature/application that needs a specification document. Also use when the user mentions "spec", "specification", "requirements document", or asks to document what a system should do.
---

# Technical Specification Writing

Specs document **what** a system does, not **how** it's implemented.

They serve as:
- Reference documentation for developers
- Requirements tracking for features
- Testing guidance for QA
- Communication tool between stakeholders

## Language Requirements

Use RFC 2119 keywords for requirement levels:
- **MUST** / **MUST NOT** — Absolute requirements
- **SHOULD** / **SHOULD NOT** — Recommended but not mandatory
- **MAY** — Optional features

Write in present tense, implementation-agnostic language. Be specific about expected behavior. No code snippets.

- Keep language high-level and implementation-agnostic
- Avoid code snippets and syntax examples
- Focus on behavior and capabilities, not implementation details
- Use present tense ("The application MUST validate...")
- Be specific about expected behavior

## Required Sections

1. **Purpose** — What the system does and why
2. **UI Layout** — ASCII diagrams of component layout
3. **Functional Requirements** — Grouped by domain (e.g., Input, Processing, Output, API Integration, Storage)
4. **Non-Functional Requirements** — Performance, styling, accessibility, security
5. **Dependencies** — Libraries and frameworks with versions
6. **Implementation Notes** — Technical details too specific for requirements (framework quirks, data formats, architectural decisions)
7. **Error Handling** — Expected error conditions and responses

### Functional Requirements

Group related requirements under clear section headers:

```markdown
### Section Name

- The application MUST do X
- The application SHOULD do Y
- The feature MAY support Z
```

Common categories:
- API Integration
- Data Input/Output
- User Interface Controls
- Status/Feedback
- Communication/Networking
- Persistence/Storage

### Non-Functional Requirements

Common categories:
- Styling/Theming
- Code Quality
- Performance
- Browser/Platform Compatibility
- Accessibility
- Security

### Implementation Notes

This section captures technical details that are too specific for requirements but important to document:

- Framework-specific behaviors (e.g., "jQuery wraps native events")
- Data format considerations (e.g., "Images stored as data URLs")
- API integration patterns (e.g., "Model selection uses APIClass:model-name format")
- Browser API quirks and workarounds
- Key architectural decisions that affect implementation

**Purpose:** If implementation details creep into the spec, they belong here rather than in requirements. This keeps requirements clean while preserving important technical context.

## Formatting Guidelines

### Use Plain Markdown Lists

❌ **Avoid hierarchical numbering:**
```markdown
FR-1.1 The application MUST...
FR-1.2 The application SHOULD...
```

✅ **Use bullet points:**
```markdown
- The application MUST...
- The application SHOULD...
```

**Rationale:** Bullet points are easier to maintain. Adding, removing, or reordering requirements doesn't require renumbering.

### Use Nested Lists for Details

```markdown
- The application MUST support multiple formats:
  - JSON for data exchange
  - CSV for exports
  - XML for legacy systems
```

### UI Layout Diagrams

Use ASCII art to show component layout:

```markdown
## UI Layout

```
+-----------------------------------------------+
|  [Header Bar]                                 |
+-----------------------------------------------+
|                                               |
|  [Control Panel]                              |
|                                               |
|  +-----------------------------------+        |
|  |                                   |        |
|  |      [Main Content Area]          |        |
|  |                                   |        |
|  +-----------------------------------+        |
|                                               |
|  [Action Buttons]                             |
|                                               |
+-----------------------------------------------+
```
```

## Formatting Rules

- Use bullet points with MUST/SHOULD/MAY, not numbered requirement IDs (e.g., avoid `FR-1.1`). Bullet points are easier to maintain — adding or reordering doesn't require renumbering.
- Nest sub-items for detail
- Each MUST requirement should be testable

## Be Specific About States

Document all states: initial, transitions, success, error, edge cases.

**Vague:** "Buttons should be disabled sometimes"
**Specific:** "The submit button MUST be disabled until the form is valid" and "The submit button MUST be disabled while request is in progress"

## What to Avoid

- **No code snippets or syntax examples** — describe behavior, not implementation
- No SQL definitions, only tables of properties
- **No implementation-specific language** — "The system MUST filter invalid items" not "Use Array.prototype.filter()"
- **No design patterns in specs** — "The application MUST maintain a single API connection" not "Use a singleton pattern"

## Implementation Notes Section

This section captures technical details that are too specific for requirements but important to document: framework-specific behaviors, data format considerations, API integration patterns, browser API quirks, key architectural decisions. If implementation details creep into the spec, they belong here rather than in requirements.

## File Organization

- Name the file `SPEC.md` in the project root
- Split into `SPEC_*.md` files if too large
- Keep synchronized with implementation

## Review Checklist

Before finalizing, verify:
- All MUST requirements are testable
- SHOULD vs MUST is used appropriately
- No code snippets or syntax examples
- Requirements are implementation-agnostic
- UI layout is visually documented
- Error conditions are documented
- Dependencies are listed with versions
- Language is clear and specific
