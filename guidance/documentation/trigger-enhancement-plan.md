---
type: guidance
status: current
category: documentation
tags:
  - triggers
  - implementation
  - planning
focus_levels:
  - implementation
---

# Trigger Enhancement Plan

## Phase 1: High-Priority Files (15 files)

### Global Guidance (~/.claude/guidance/)

#### 1. testing/test-driven-development.md
```yaml
file_triggers:
  - "*_spec.rb"
  - "*.spec.rb"
  - "*.spec.js"
  - "*.spec.ts"
  - "*.test.js"
  - "*.test.ts"
directory_triggers:
  - "spec/**"
  - "test/**"
```

#### 2. development-process/tdd-human-review-cycle.md
```yaml
file_triggers:
  - "*_spec.rb"
  - "*.spec.rb"
  - "*.spec.js"
  - "*.spec.ts"
  - "*.test.js"
  - "*.test.ts"
directory_triggers:
  - "spec/**"
  - "test/**"
```

#### 3. frontend/css-architecture.md
```yaml
file_triggers:
  - "*.css"
  - "*.scss"
  - "*.sass"
  - "*.less"
```

#### 4. frontend/debugging-workflow.md
```yaml
file_triggers:
  - "*.js"
  - "*.ts"
  - "*.jsx"
  - "*.tsx"
  - "*.vue"
directory_triggers:
  - "src/**"
  - "app/javascript/**"
```

#### 5. code-quality/immediately-runnable-code.md
```yaml
file_triggers:
  - "*.rb"
  - "*.js"
  - "*.ts"
  - "*.py"
  - "*.java"
```

#### 6. code-quality/general-code-writing.md
```yaml
file_triggers:
  - "*.rb"
  - "*.js"
  - "*.ts"
  - "*.py"
  - "*.java"
  - "*.go"
```

### Project-Specific (musashi)

#### 7. musashi/rails/service-objects.md
```yaml
file_triggers:
  - "*_service.rb"
directory_triggers:
  - "app/services/**"
```

#### 8. musashi/rails/crud-controllers.md
```yaml
file_triggers:
  - "*_controller.rb"
directory_triggers:
  - "app/controllers/**"
```

#### 9. musashi/rails/models.md
```yaml
file_triggers:
  - "*.rb"
directory_triggers:
  - "app/models/**"
```

#### 10. musashi/rails/backend-testing.md
```yaml
file_triggers:
  - "*_spec.rb"
  - "*.spec.rb"
directory_triggers:
  - "spec/**"
```

#### 11. musashi/rails/fixture-based-testing.md
```yaml
file_triggers:
  - "*.yml"
  - "*.yaml"
directory_triggers:
  - "spec/fixtures/**"
  - "test/fixtures/**"
```

#### 12. musashi/vue/component-patterns.md
```yaml
file_triggers:
  - "*.vue"
directory_triggers:
  - "src/components/**"
  - "app/javascript/components/**"
```

#### 13. musashi/vue/frontend-testing.md
```yaml
file_triggers:
  - "*.spec.js"
  - "*.spec.ts"
  - "*.test.js"
  - "*.test.ts"
directory_triggers:
  - "spec/javascript/**"
  - "test/javascript/**"
```

#### 14. musashi/vue/styling-patterns.md
```yaml
file_triggers:
  - "*.vue"
  - "*.scss"
  - "*.css"
directory_triggers:
  - "src/components/**"
  - "app/assets/stylesheets/**"
```

#### 15. musashi/rails/api-patterns.md
```yaml
file_triggers:
  - "*_controller.rb"
directory_triggers:
  - "app/controllers/api/**"
```

## Implementation Order

1. **Global testing guidance** (#1, #2) - Most commonly triggered
2. **Global code quality** (#5, #6) - Applies broadly
3. **Rails backend** (#7, #8, #9, #10) - Core Rails patterns
4. **Frontend** (#3, #4, #12, #14) - Frontend development
5. **Testing patterns** (#11, #13, #15) - Specialized testing

## Validation Checklist

For each file:
- [ ] Frontmatter syntax is valid YAML
- [ ] File patterns use correct glob syntax
- [ ] Directory patterns use `/**` for recursive matching
- [ ] Patterns match actual project structure
- [ ] No overly broad triggers (avoid triggering on everything)
- [ ] Test by creating sample file and verifying trigger

## Notes

- Start with narrow triggers, can expand later
- Project-specific triggers are more specific than global
- Some files deliberately have no triggers (architecture, therapy, etc.)
- Triggers can be adjusted based on usage patterns
