---
type: bundle
layer: domain
parent: foundation/software-dev.md
context: Developing AI systems, prompts, agents, and LLM integrations
estimated_lines: 550
focus_levels:
- design
- implementation
---

# Domain: AI Development

Comprehensive guidance for developing AI-powered systems, including prompt engineering, agent design, and LLM integration patterns.

## Parent Bundle
@../foundation/software-dev.md

## Prompt Engineering Fundamentals

### Core Techniques
@../../ai-development/structured-formatting.md
@../../ai-development/instruction-clarity.md
@../../ai-development/context-optimization.md
@../../ai-development/output-control.md
@../../ai-development/reasoning-patterns.md
@../../ai-development/prompt-structure.md

### Platform-Specific
@../../ai-development/claude-prompting.md

## Agent & System Design
@../../ai-development/command-task-isolation.md

## Communication Patterns
@../../communication/balanced-analysis.md
@../../communication/developer-tone.md

## Testing & Validation
When developing AI systems, consider:
- Prompt regression testing
- Output consistency validation
- Edge case handling
- Hallucination detection
- Performance benchmarking

## Best Practices for AI Development

### Prompt Versioning
- Track prompt changes like code
- A/B test prompt variations
- Document prompt evolution
- Maintain prompt libraries

### Context Management
- Budget token usage carefully
- Implement sliding windows for conversations
- Use RAG for large knowledge bases
- Cache frequently used contexts

### Error Handling
- Graceful degradation when AI fails
- Fallback to simpler prompts
- Human-in-the-loop patterns
- Confidence thresholds

### Agent Architectures
- Single-purpose agents over multi-purpose
- Clear boundaries between agents
- Explicit handoff protocols
- State management strategies

### Integration Patterns
- API abstraction layers
- Model-agnostic interfaces
- Response parsing and validation
- Rate limiting and retry logic

## Anti-patterns
- Over-engineering prompts before testing
- Ignoring model-specific optimizations
- Assuming deterministic outputs
- Neglecting error cases
- Hardcoding model assumptions
- Mixing concerns in single agents