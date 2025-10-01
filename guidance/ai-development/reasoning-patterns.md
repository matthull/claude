---
type: guidance
status: current
category: ai-development
tags:
- ai-development
---

# Reasoning Patterns in Prompts

## Core Concepts

### Step-by-Step Thinking
- Explicitly request: "Think through this step-by-step"
- Break complex problems into numbered steps
- Require showing work: "Show your reasoning for each step"
- Use progressive disclosure: solve subproblems before main problem
- Make intermediate conclusions explicit

### Chain-of-Thought (CoT)
- Add "Let's think about this systematically" for complex reasoning
- Request explanation before answer: "First explain your approach, then provide the answer"
- Use zero-shot CoT: "Think step by step" without examples
- Use few-shot CoT: provide examples showing reasoning process
- Separate reasoning from final answer with clear markers

### Task Decomposition
- Break complex tasks into atomic subtasks
- Number subtasks for clear execution order
- Define dependencies between subtasks explicitly
- Use prompt chaining: output of one prompt feeds the next
- Create decision trees for conditional logic

### Working Memory Management
- Instruct to track key information: "Keep track of..."
- Use scratch space: "Use a working area to note..."
- Request state summaries: "After each step, summarize what you know"
- Build solutions incrementally rather than all at once
- Explicitly maintain context across steps

### Verification Patterns
- Include self-checking: "Verify your answer by..."
- Request confidence scores: "Rate confidence 1-10"
- Ask for alternative approaches: "Solve this another way to verify"
- Build in error detection: "Check for logical inconsistencies"
- Require justification: "Explain why this answer is correct"

### Reasoning Frameworks
- For analysis: "Consider perspectives from X, Y, and Z"
- For evaluation: "Assess based on criteria: A, B, C"
- For problem-solving: "1) Understand 2) Plan 3) Execute 4) Verify"
- For decisions: "List pros, cons, then conclude"
- For debugging: "1) Identify symptom 2) Form hypothesis 3) Test 4) Iterate"

## When to Apply
- Mathematical or logical problems
- Multi-step procedures
- Complex analysis requiring multiple perspectives
- Tasks where showing work is valuable
- Problems where verification is critical
- Debugging or troubleshooting scenarios

## Anti-patterns
- Asking for reasoning after the answer
- Skipping intermediate steps in complex problems
- Not providing space for working through problems
- Mixing reasoning with output format requirements
- Over-decomposing simple tasks
- Requesting reasoning without using it