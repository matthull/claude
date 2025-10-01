---
type: guidance
status: current
category: testing
---

# Integration Mocking Guidelines

## WebMock vs VCR

Use WebMock for simple APIs (single endpoints, predictable patterns), VCR for complex APIs (multi-step flows, authentication sequences, many endpoints). Always ask user which to use before starting tests.
