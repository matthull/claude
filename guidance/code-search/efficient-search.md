---
type: guidance
status: current
category: code-search
---

# Efficient Code Search

## Search Hierarchy
```
Cheapest → Most Expensive
1. Glob patterns: ~50 tokens
2. Grep/ripgrep: ~200 tokens
3. File read: 500-5000 tokens
4. AI agent: 2000-8000 tokens
```

## Tool Selection
- **Glob**: File names, paths (ALWAYS first)
- **Grep/rg**: Content patterns (ALWAYS second)
- **Read**: Only when location known
- **Agent**: Complex semantic searches only

## Search Patterns

### Finding Definitions
```bash
# Classes
rg "^class\s+\w+" -t py
rg "^\s*class\s+" -t ruby

# Functions
rg "^def\s+\w+" -t py
rg "function\s+\w+|const\s+\w+\s*=" -t js

# Always use type flags
-t py, -t js, -t ruby, -t go
```

### Finding Entry Points
```bash
# Main files
glob: "**/main.{py,js,rb,go}"
glob: "**/index.{js,jsx,ts,tsx}"
glob: "**/app.{py,js,rb}"

# Routes/URLs
glob: "**/routes*"
glob: "**/urls.py"
```

### Finding Tests
```bash
glob: "**/*{test,spec}.{js,py,rb}"
glob: "**/test/**/*.{js,py,rb}"
glob: "**/spec/**/*.rb"
```

### Finding Config
```bash
glob: "**/*.config.{js,json}"
glob: "**/.env*"
glob: "**/config/**/*.{yml,yaml}"
```

## Parallel Search Strategy
```bash
# GOOD: Launch simultaneously
auth_files=$(glob "**/auth*") &
user_files=$(glob "**/user*") &
test_files=$(glob "**/*test*") &
wait

# BAD: Sequential
Search A → wait → Search B → wait
```

## Multi-Step Flows

### Understanding Feature
1. Find routes: `glob "**/routes*"`
2. Extract handler from routes
3. Find handler: `glob "**/{handler}*"`
4. Find models: `grep "Model|Schema"`
5. Find tests: `glob "**/*test*{feature}*"`

### Tracking Data Flow
1. Find source: `grep "fetch|query|select"`
2. Find transform: `grep "map|filter|reduce"`
3. Find consumers: `grep "{variable}"`
4. Find effects: `grep "setState|dispatch"`

## Context Extraction
```bash
# Function with body
rg -A 30 "def function_name"

# Class method list only
rg -A 50 "class ClassName" | grep "def "

# Imports only
head -50 file.py | grep "import"
```

## Performance Rules

### Use ripgrep over grep
```bash
# BAD: grep
grep -r "pattern" .

# GOOD: ripgrep
rg "pattern"
```

### Early termination
```bash
# Stop at first match
rg "pattern" -m 1

# Limit results
rg "pattern" | head -20
```

### Cache searches
```bash
auth_files=$(glob "**/auth*")
echo "$auth_files" | xargs rg "login"
echo "$auth_files" | xargs rg "logout"
```

## Search Recovery

### Progressive Expansion
1. Most specific pattern
2. Broaden slightly
3. Check different locations
4. Try naming variations
5. Use semantic agent

### Name Variations
- camelCase: `getUserName`
- snake_case: `get_user_name`
- kebab-case: `get-user-name`
- PascalCase: `GetUserName`

## Anti-patterns
- NEVER: Read files to search them
- NEVER: Recursive file reads
- NEVER: Search without type filters
- NEVER: Sequential when parallel possible
- NEVER: Full codebase scan (use agent)