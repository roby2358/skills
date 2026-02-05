---
name: specification
description: Guidelines for writing technical specifications. Use when creating or updating SPEC.md files for applications or features.
---

# Technical Specification Writing

## Purpose

Technical specifications document **what** a system does, not **how** it's implemented. They serve as:
- Reference documentation for developers
- Requirements tracking for features
- Testing guidance for QA
- Communication tool between stakeholders

## Language Requirements

### RFC 2119 Keywords

Use standardized requirement language:

- **MUST** / **MUST NOT** - Absolute requirements
- **SHOULD** / **SHOULD NOT** - Recommended but not mandatory
- **MAY** - Optional features

### Writing Style

- Keep language high-level and implementation-agnostic
- Avoid code snippets and syntax examples
- Focus on behavior and capabilities, not implementation details
- Use present tense ("The application MUST validate...")
- Be specific about expected behavior

## Document Structure

### Required Sections

1. **Purpose** - Brief description of what the system does
2. **UI Layout** - Visual representation using ASCII diagrams
3. **Functional Requirements** - What the system does
4. **Non-Functional Requirements** - How the system behaves
5. **Dependencies** - External libraries and frameworks
6. **Implementation Notes** - Key technical considerations
7. **Error Handling** - Expected error conditions

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

## What to Include

### Be Specific About States

❌ **Vague:**
```markdown
- Buttons should be disabled sometimes
```

✅ **Specific:**
```markdown
- The submit button MUST be disabled until form is valid
- The submit button MUST be disabled while request is in progress
```

### Document Expected Behavior

Include:
- Initial states
- State transitions
- Success conditions
- Error conditions
- Edge cases

### Dependencies

List required libraries and frameworks:

```markdown
## Dependencies

**Libraries:**
- jQuery 3.6.4 for DOM manipulation
- D3.js for data visualization
- Marked.js for markdown rendering
```

### Implementation Notes

Document critical technical details without code:

```markdown
## Implementation Notes

### Event Handling
jQuery wraps native browser events. Native event properties must be accessed through the originalEvent property.

### Data Format
Images are converted to data URLs containing the media type and base64-encoded image data.
```

## What to Avoid

### Don't Include Code

❌ **Avoid:**
```markdown
The function should use:
```javascript
function example() { ... }
```
```

✅ **Instead:**
```markdown
- The function MUST validate input before processing
- The function SHOULD return structured error objects
```

### Don't Describe Implementation

❌ **Too specific:**
```markdown
- Use Array.prototype.filter() to remove invalid items
- Call setState() after each update
```

✅ **High-level:**
```markdown
- The system MUST filter invalid items before processing
- The UI MUST update after each state change
```

### Don't Mix Requirements and Design

Keep specs focused on **what**, not **how**:

❌ **Design decision in spec:**
```markdown
- Use a singleton pattern for the API client
```

✅ **Requirement:**
```markdown
- The application MUST maintain a single API connection
```

## Review Checklist

Before finalizing a spec, verify:

- [ ] All MUST requirements are testable
- [ ] SHOULD vs MUST is used appropriately
- [ ] No code snippets or syntax examples
- [ ] Requirements are implementation-agnostic
- [ ] UI layout is visually documented
- [ ] Error conditions are documented
- [ ] Dependencies are listed
- [ ] Language is clear and specific
- [ ] Uses bullet points, not numbered lists

## Example Spec Structure

```markdown
# Feature Name - Technical Specification

Brief description of what this feature does.

## Purpose

Why this feature exists and what problem it solves.

## UI Layout

ASCII diagram of the interface.

## Functional Requirements

### Input Handling

- The system MUST accept X format
- The system SHOULD validate Y
- The system MAY support Z

### Processing

- The application MUST transform data according to rules
- The application SHOULD handle edge cases gracefully

### Output

- The system MUST provide results in X format
- The system SHOULD include metadata

## Non-Functional Requirements

### Performance

- The system MUST respond within X seconds
- The system SHOULD handle Y concurrent requests

### Styling

- The application MUST use consistent theming
- The UI SHOULD be responsive

## Dependencies

**Libraries:**
- Framework X for Y
- Library Z for W

## Implementation Notes

### Key Technical Considerations

Brief descriptions of critical technical details.

## Error Handling

The application MUST handle these error conditions:
- Condition A
- Condition B
- Condition C
```

## When to Create a Spec

Create a SPEC.md when:
- Starting a new feature or application
- Documenting existing functionality
- Planning major refactors
- Clarifying requirements with stakeholders

Update the spec when:
- Requirements change
- New edge cases are discovered
- Features are added or removed
- Behavior changes

Keep the spec synchronized with implementation to maintain its value as documentation.

If the SPEC is too large, break it up into SPEC_*.md

Remember, the SPEC.md is a work product!
