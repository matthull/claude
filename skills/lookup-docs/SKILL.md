---
description: Look up technical documentation for libraries and tools. Use this instead of guessing APIs, configurations, or implementation details. Triggers on phrases like "look up docs", "check documentation", "how does X work", or when uncertain about an API or configuration.
---

# Lookup Technical Documentation

When you need to know how a library, framework, or tool works - **look it up, don't guess**.

## When to Use This

- Before using an API you haven't verified
- When configuring a tool or service
- When you think "it probably works like..." - STOP and look it up
- When implementation details matter (versions, options, patterns)

## Process

### 1. Try Context7 First

Use the `mcp__context7__resolve-library-id` tool to find the library:

```
mcp__context7__resolve-library-id({ libraryName: "library-name" })
```

Then fetch docs with `mcp__context7__get-library-docs`:

```
mcp__context7__get-library-docs({
  context7CompatibleLibraryID: "/org/library",
  topic: "specific topic"
})
```

Context7 has curated, up-to-date documentation for many popular libraries.

### 2. Fall Back to Web Search

If Context7 doesn't have the library or the topic isn't covered:

```
WebSearch({ query: "library-name topic 2025" })
```

Then fetch specific pages with `WebFetch` if needed.

### 3. Verify Before Using

After looking up documentation:
- Confirm the version matches what the project uses
- Note any caveats or requirements
- If docs are unclear or incomplete, say so - don't fill gaps with assumptions

## Anti-patterns

- "It probably has a `config` option..." - STOP, look it up
- "Usually you would..." - STOP, verify for this specific library
- "I think the API is..." - STOP, check the docs
- Mixing up versions or similar libraries - ALWAYS verify
- Assuming one library works like another - VERIFY

## When Docs Are Insufficient

If documentation doesn't answer the question:
1. State clearly what's missing
2. Search for examples, blog posts, or GitHub issues
3. If still unclear, ask the user rather than guess
