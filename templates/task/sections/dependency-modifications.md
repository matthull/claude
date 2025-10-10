---
type: task-template
section: dependency-modifications
description: Explicit requirements when modifying existing classes or dependencies
applies_to: all
source_guidance:
  global:
    - testing/test-driven-development
    - development-process/tdd-human-review-cycle
---

## Dependency Modifications (CRITICAL)

<!-- PLANNER NOTE: Include this section WHENEVER adding methods to existing classes -->

### API Documentation Extraction (if modifying API clients)

**You MUST extract specs BEFORE modifying any API client:**

```markdown
**Doc URL**: [exact URL fetched]
**HTTP Method**: [QUOTE from docs]
**Endpoint Path**: [QUOTE from docs]
**Content-Type**: [QUOTE from docs]
**Field Names**: [QUOTE exact field names]
```

### Modified Classes Testing Requirements

**You are modifying these existing classes:**
{LIST_OF_MODIFIED_CLASSES}

**CRITICAL: Each modified class MUST have dedicated tests:**

#### {CLASS_1_NAME} Modifications

**File**: `{CLASS_1_PATH}`
**New Methods**: {NEW_METHOD_NAMES}

**Required Tests** (`{SPEC_PATH_FOR_CLASS_1}`):
```ruby
describe '#{NEW_METHOD_1}' do
  it '{SUCCESS_SCENARIO}', :vcr do
    # Test method directly at this layer
    # NOT through service that uses it
  end

  it '{ERROR_SCENARIO}', :vcr do
    # Test error handling at this layer
  end
end
```

**Loop 1a (Dependency TDD)**:
```bash
bundle exec rspec {SPEC_PATH_FOR_CLASS_1}
```

#### {CLASS_2_NAME} Modifications (if applicable)

**File**: `{CLASS_2_PATH}`
**New Methods**: {NEW_METHOD_NAMES}

**Required Tests** (`{SPEC_PATH_FOR_CLASS_2}`):
```ruby
# Similar test structure as above
```

### Testing Order (MANDATORY)

**You MUST follow this exact testing sequence:**

1. **Loop 0 (Dependencies)**: Test each modified class FIRST
   - Write failing test for new Client method
   - Implement Client method
   - Verify Client spec passes
   - ONLY THEN proceed to Service

2. **Loop 1 (Primary)**: Test main service/controller
   - Now you can mock/stub the tested Client method
   - Focus on Service logic

3. **Loop 2 (Project)**: Full test suite
   - All specs must pass

### Verification Commands

**Loop 0 (Dependency Tests)** - RUN FIRST:
```bash
# Test each modified class individually
{DEPENDENCY_TEST_COMMANDS}
```

**Loop 1 (Primary TDD)**:
```bash
{PRIMARY_TEST_COMMAND}
```

**Loop 2 (Scoped)**:
```bash
{PROJECT_TEST_COMMAND}
```

### Dependency Checklist

**Before Starting Primary Implementation**:
- [ ] **CRITICAL: Every new method in dependencies has tests**
- [ ] All dependency tests written FIRST (TDD red)
- [ ] All dependency tests passing (TDD green)
- [ ] VCR cassettes recorded for external calls
- [ ] Error scenarios tested (404, 401, 500)

### Common Mistakes to AVOID

**You MUST NEVER**:
- ❌ **Skip dependency tests** (biggest failure mode)
- ❌ Add methods to Client without Client specs
- ❌ Test Client only through Service specs
- ❌ Proceed to Service before Client tests pass
- ❌ Mock untested dependencies

**You MUST ALWAYS**:
- ✅ Test at the layer where method is defined
- ✅ Write dependency tests BEFORE service tests
- ✅ Verify dependency specs pass in isolation
- ✅ Only mock/stub tested dependencies