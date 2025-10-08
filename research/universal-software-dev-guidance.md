# Universal Software Development Guidance

Files containing general software development principles relevant at more or less all times.

## Core Development Process (3 files)

1. `development-process/no-interface-guessing.md`
   - NEVER guess interfaces, always search/verify
   - STOP. SEARCH. VERIFY. OR ASK.
   - Red flags: "It probably has...", "Usually this would..."

2. `development-process/tdd-human-review-cycle.md`
   - TDD with mandatory human review cycles
   - RED → GREEN → STOP → REFACTOR → COMMIT → REPEAT
   - Never proceed to refactor without human approval

3. `development-process/brownfield-development.md`
   - Assume existing code works
   - Search for patterns before creating new ones
   - Extend existing models, don't create parallel structures
   - Planning anti-patterns: over-specification, premature abstraction

## Code Quality (3 files)

4. `code-quality/code-review-principles.md`
   - Always provide pros and cons
   - Review priority: Correctness → Security → Performance → Maintainability → Style
   - Feedback categories: [BLOCKING], [SHOULD], [CONSIDER], [NIT]

5. `code-quality/general-code-writing.md`
   - Aggregates TDD, error handling, security principles
   - Quick checklist for all code
   - When to apply each principle

6. `code-quality/immediately-runnable-code.md`
   - Full implementations, no placeholders
   - All imports, error handling, edge cases
   - Completeness checklist before presenting code

## Testing (1 file)

7. `testing/test-driven-development.md`
   - RED-GREEN-REFACTOR cycle
   - Testing pyramid: Unit 70%, Integration 20%, E2E 10%
   - FIRST principles: Fast, Isolated, Repeatable, Self-validating, Timely
   - Critical: Run tests after ANY change, fix failures immediately

## Security (2 files)

8. `security/validation-and-authorization.md`
   - Never trust client data
   - Check at every layer
   - Defense in depth
   - Common attack prevention patterns

9. `security/code-security-boundaries.md`
   - Hard boundaries: never create exploit code, credential harvesters
   - Defensive security: always allowed
   - Decision framework for when to refuse/proceed

## Communication (2 files)

10. `communication/balanced-analysis.md`
    - ALWAYS provide pros and cons
    - NEVER be a "yes man"
    - Challenge assumptions, identify risks
    - Red flags for "quick fix" mentality

11. `communication/developer-tone.md`
    - Peer-to-peer communication
    - Match formality, echo terminology
    - Supportive, direct, honest, constructive
    - Adaptive responses for beginners vs experts

## Architecture (2 files)

12. `architecture/cross-layer-impact.md`
    - Impact analysis framework
    - Data flow mapping, contract changes, dependency chains
    - Implementation sequence: Data → Logic → API → UI → Integration
    - Critical questions for impact, integration, testing

13. `architecture/api-integration.md`
    - NEVER guess API structure or parameters
    - ALWAYS use only what's in documentation
    - Required information before coding: URL, method, headers, body, response
    - When documentation missing: ASK user, never assume

## Efficiency (2 files)

14. `code-search/efficient-search.md`
    - Search hierarchy: Glob (~50 tokens) → Grep (~200) → Read (500-5000) → Agent (2000-8000)
    - Tool selection optimization
    - Parallel search strategies
    - Name variations: camelCase, snake_case, kebab-case, PascalCase

15. `ai-development/context-optimization.md`
    - Information density: remove fillers, use contractions
    - Context budget: Instructions 20%, Context 60%, Examples 20%
    - Token-aware writing
    - Preserve meaning over compression

## Documentation & Process (2 files)

16. `documentation/task-handoffs.md`
    - Task completion gates: Loop 1 (unit tests) → Loop 2 (project-wide verification)
    - FAILING SPECS = INCOMPLETE TASK - NO EXCEPTIONS
    - Handoff template for pausing work
    - Deferred items tracking

17. `documentation/project-workflow.md`
    - Directory structure for projects
    - Naming conventions
    - Task workflow
    - Anti-patterns: no nested folders beyond 3 levels

## Currently Referenced in Foundation Bundle

`bundles/foundation/software-dev.md` includes:
- code-security-boundaries.md ✓
- balanced-analysis.md ✓
- no-interface-guessing.md ✓

## Analysis Categories for Next Steps

### Candidates for --append-system-prompt (Always Critical)
- TBD: Files that should ALWAYS be in context

### Candidates for Planning Templates
- TBD: Files relevant during planning phase

### Candidates for Implementation Context
- TBD: Files relevant during active coding

### Candidates for Review/Quality Gates
- TBD: Files for code review and completion checks

### On-Demand Loading
- TBD: Files to load only when specifically relevant
