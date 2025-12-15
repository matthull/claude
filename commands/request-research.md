# Request Research

Create a research request document for: $ARGUMENTS

## Output

Save to `research/requests/[topic-slug].md` in the project root.

The document should be usable by any research agent (Claude Code, Claude.ai, or other tools). Assume the agent knows HOW to research — focus on WHAT and WHY.

**Important:** The researcher has NO access to this repo. Bake in all relevant context — do not link to internal docs. Read relevant project docs first, then include the necessary context directly in the request.

## Document Structure

```markdown
# Research Request: [Topic]

**Created:** [date]
**Status:** Open

## Goal
What we're trying to learn or decide. Be specific about the outcome needed.

## Context
Why this matters. Include all relevant background directly — the researcher cannot access our repo. Explain:
- What project/situation this is for
- What decisions depend on this research
- Any constraints or requirements

## Key Questions
Numbered list of specific questions to answer. These should be:
1. Concrete and answerable
2. Prioritized (most important first)
3. Scoped appropriately (not too broad, not too narrow)

## What Would Change Our Approach
What findings would actually shift our strategy or decisions? This helps the researcher focus on actionable insights rather than general background.

## Known Assumptions to Challenge
Any beliefs we currently hold that should be tested. Be explicit about what we think we know — and why we might be wrong.

## Output Format
What format is most useful? Options:
- Summary with sources
- Comparison table
- Pro/con analysis
- Step-by-step guide
- Annotated source list

## Recency Requirements
[Specify how important recency is for this topic:]
- Critical (2024-2025 only) — fast-moving landscape, older content likely outdated
- Prefer recent — recent sources preferred but older foundational content acceptable
- Not critical — topic is stable, older sources fine

## Instructions for Researcher
- Ask clarifying questions before diving in if scope is unclear or assumptions seem off
- Push back if the questions seem misguided or if there's a better framing
- Cite sources for all claims (note publication dates)
- Distinguish between well-established findings and emerging/contested ideas
- Be direct about limitations or gaps in available evidence
```

## After Creating

1. Create `research/requests/` directory if it doesn't exist
2. Inform user where the request was saved
3. Note that findings should go in `research/findings/[topic-slug].md` when fulfilled

## Principles
- Bake in all context — researcher cannot access our files
- Be specific about what decisions this research informs
- Encourage the researcher to push back and ask questions
- Don't over-specify methodology — trust the researcher
