---
type: validation-checklist
name: handoff-validation
description: Self-check before finalizing any task handoff
---

# Handoff Validation Checklist

## CRITICAL: Before Writing Handoff to Disk

**You MUST perform this self-check BEFORE using Write tool:**

### Code Block Line Count Check

1. **Scan entire handoff for code blocks** (between ``` markers)
2. **Count lines in each code block**
3. **FAIL if any code block > 5 lines** (unless it's bash commands)

**Exceptions:**
- ✅ Bash commands for verification (grep, cat, find, etc.)
- ✅ Brief 1-5 line reference snippets with comments
- ❌ Full method implementations
- ❌ Complete class definitions
- ❌ Complete test implementations

### Content Pattern Check

**FAIL if handoff contains:**
- ❌ `class SomeClass` followed by full class body
- ❌ `def method_name` followed by complete implementation
- ❌ `it 'test description' do` followed by complete test
- ❌ Multiple methods shown in sequence with implementations
- ❌ Full file contents reproduced (except when referencing canonical examples)

**PASS if handoff contains:**
- ✅ Method names with brief purpose descriptions
- ✅ Test scenario descriptions without code
- ✅ References to existing code by line numbers
- ✅ Small 1-5 line snippets showing specific patterns
- ✅ API contracts (input/output specifications)

### Self-Correction Protocol

**IF validation fails:**

1. **STOP immediately before Write**
2. **Rewrite problematic sections** to:
   - Replace implementations with descriptions
   - Replace test code with scenario descriptions
   - Add line number references instead of code reproduction
3. **Re-run validation**
4. **Only Write when validation passes**

---

## Example Violations vs Corrections

### VIOLATION: Full Class Implementation
```ruby
# ❌ TOO MUCH DETAIL
class BaseSyncableAssetsFinder
  Result = Struct.new(:count, :asset_identifiers, keyword_init: true)

  def initialize(account:, settings:)
    @account = account
    @settings = settings
  end

  def call
    asset_identifiers = Set.new
    syncable_types.each do |type|
      # ... 10 more lines
    end
  end
end
```

### CORRECTION: Description with References
```
**Base class required**: `BaseSyncableAssetsFinder`

**Extract from Highspot finder:**
- Result struct (lines 17-18)
- Initialization pattern (lines 25-28)
- Iteration loop structure (lines 40-57)

**Methods required:**
- `call` - Main entry point, returns Result with count and asset_identifiers
- `syncable_types` - Abstract method, raises NotImplementedError
- `add_public_assets(identifiers, scope, type)` - Shared logic from Highspot lines 69-84

**Reference existing pattern:** `app/services/bulk_actions/highspot/syncable_assets_finder.rb`
```

---

### VIOLATION: Complete Test Code
```ruby
# ❌ TOO MUCH DETAIL
describe '#call' do
  it 'returns correct count' do
    # Arrange
    account = create(:account)
    finder = described_class.new(account: account)

    # Act
    result = finder.call

    # Assert
    expect(result.count).to eq(5)
    expect(result.asset_identifiers.size).to eq(5)
  end
end
```

### CORRECTION: Test Scenario Description
```
**Test scenarios required:**

1. **Happy path**: Finder returns Result with correct count and asset_identifiers array
   - Reference similar test in: `spec/services/bulk_actions/highspot/syncable_assets_finder_spec.rb:45-55`

2. **Edge case**: No settings returns zero count and empty array
   - Verify Result struct construction
   - Verify early return behavior

3. **Abstract methods**: Calling unimplemented methods raises NotImplementedError
   - Test each abstract method (syncable_types, integration_id_column, should_sync_asset?)
```

---

## Quick Visual Check

**Red flags to look for:**

- 🚩 Code blocks longer than ~10 visible lines
- 🚩 Multiple method definitions shown in sequence
- 🚩 `class ClassName` followed by full class body
- 🚩 Test blocks with Arrange/Act/Assert filled in
- 🚩 More code than prose in any section

**Green flags to expect:**

- ✅ Line number references like "Extract from lines 17-18"
- ✅ Prose descriptions: "Method should return X when Y"
- ✅ Test scenarios: "Verify behavior when condition occurs"
- ✅ Pointers: "Similar to existing_file.rb:45-50"
- ✅ Contracts: "Accepts account, returns Result struct"
