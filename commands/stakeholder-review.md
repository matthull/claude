# /stakeholder-review

## Purpose
Generate stakeholder review documents from project specs through interactive discussion.

## Usage
```
/stakeholder-review
```

## Implementation

Load stakeholder review guidance:
@~/.claude/guidance/documentation/stakeholder-review.md

## Process

1. **Load Current Spec**
   - Find and read spec.md or specification.md in current project
   - If multiple specs exist, ask which one

2. **Interactive Discussion**
   - WHO: Which stakeholders need to review?
   - WHAT: What decisions do they need to make?
   - SLICE: Which parts of the spec are relevant to them?
   - CHANNEL: How will they review (doc/meeting/slack)?

3. **Generate Review Document**
   - Create focused document per stakeholder group
   - Extract only relevant spec sections
   - Frame clear yes/no decisions
   - Set review deadline

4. **Output**
   - Save as `review-[stakeholder].md`
   - Provide summary of what was generated
   - Suggest next steps for distribution

## Example Flow
```
User: /stakeholder-review
Assistant: Loading spec.md... Found 1200 lines.
Assistant: Let's discuss the review. Who needs to review this feature?
User: Product team and engineering lead
Assistant: What decisions does product need to make?
User: Whether the MVP scope is right for initial launch
Assistant: What about engineering?
User: Technical feasibility and resource needs
[continues interactively...]
```