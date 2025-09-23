---
type: guidance
status: current
category: code-search
---

# Code Search Techniques

## Language-Specific Patterns

**IMPORTANT**: Always prefer `rg` (ripgrep) over `grep` for speed. Use `fd` over `find` for file discovery.

### Ruby/Rails
```bash
# Class definitions
rg "^\s*class\s+UserController" -t ruby

# Method definitions
rg "^\s*def\s+authenticate" -t ruby

# Module inclusions
rg "include\s+Authentication" -t ruby

# Rails-specific
glob: "app/controllers/**/*_controller.rb"
glob: "app/models/**/*.rb"
glob: "config/routes.rb"
```

### JavaScript/TypeScript
```bash
# Function declarations
rg "function\s+handleSubmit|const\s+handleSubmit\s*=" -t js -t ts

# Class definitions
rg "class\s+.*Component|export\s+class" -t js -t ts

# Imports
rg "import.*from\s+['\"].*auth" -t js -t ts

# React components
glob: "src/components/**/*.{jsx,tsx}"
glob: "src/pages/**/*.{jsx,tsx}"
```

### Python
```bash
# Class definitions
rg "^class\s+\w+.*:" --include="*.py"

# Function definitions
rg "^def\s+\w+.*:" --include="*.py"

# Imports
rg "^from\s+.*import\|^import\s+" --include="*.py"

# Django-specific
glob: "**/views.py"
glob: "**/models.py"
glob: "**/urls.py"
```

## Search Techniques by Goal

### Finding Entry Points
```bash
# Main functions/files
rg "if\s+__name__.*==.*__main__" --include="*.py"
rg "function\s+main\|async\s+function\s+main" --include="*.{js,ts}"
glob: "**/main.{py,js,ts,rb,go}"
glob: "**/index.{js,jsx,ts,tsx}"
glob: "**/app.{py,js,ts,rb}"
```

### Finding Configuration
```bash
# Config files
glob: "**/{config,settings}/**/*.{json,yml,yaml,toml,ini}"
glob: "**/*.config.{js,ts,json}"
glob: "**/.env*"

# Environment variables
rg "process\.env\.\|ENV\[" --include="*.{js,ts,rb,py}"
rg "os\.environ\|os\.getenv" --include="*.py"
```

### Finding Tests
```bash
# Test files
glob: "**/*{test,spec}.{js,jsx,ts,tsx,py,rb}"
glob: "**/test/**/*.{js,jsx,ts,tsx,py,rb}"
glob: "**/tests/**/*.{js,jsx,ts,tsx,py,rb}"
glob: "**/spec/**/*.rb"

# Test patterns
rg "describe\s*\(\|it\s*\(\|test\s*\(" --include="*.{js,jsx,ts,tsx}"
rg "def\s+test_\|class.*Test" --include="*.py"
```

### Finding API Endpoints
```bash
# REST endpoints
rg "@app\.route\|@router\." --include="*.py"  # Flask/FastAPI
rg "routes\.\(get\|post\|put\|delete\)" --include="*.{js,ts}"  # Express
rg "^\s*\(get\|post\|put\|delete\)\s+['\"]" --include="*.rb"  # Rails routes

# GraphQL
glob: "**/*{resolver,schema,query,mutation}*.{js,ts,py,rb}"
rg "type\s+Query\|type\s+Mutation" --include="*.{graphql,gql}"
```

## Multi-Step Search Flows

### Flow 1: Understanding a Feature
```bash
# Step 1: Find entry point (parallel)
glob: "**/routes*"
glob: "**/router*"
glob: "**/urls.py"

# Step 2: Find controller/handler
grep: "path/from/routes" → extract handler name
glob: "**/{handler_name}*"

# Step 3: Find related models
grep: "Model\|Schema\|Entity" in handler file
glob: "**/models/**/*{model_name}*"

# Step 4: Find tests
glob: "**/*test*/*{feature_name}*"
```

### Flow 2: Tracking Data Flow
```bash
# Step 1: Find data source
grep: "fetch\|axios\|query\|select"

# Step 2: Find transformation
grep: "map\|filter\|reduce\|transform"

# Step 3: Find consumers
grep: "{variable_name}" with context

# Step 4: Find side effects
grep: "setState\|dispatch\|emit"
```

## Optimized Search Combinations

### Fast Full-Stack Search
```bash
# Launch all in parallel:
frontend_components=$(glob "src/components/**/*.{jsx,tsx}")
backend_routes=$(glob "app/controllers/**/*.rb")
models=$(glob "app/models/**/*.rb")
tests=$(glob "spec/**/*_spec.rb")
configs=$(glob "config/**/*.{yml,json}")
```

### Dependency Search
```bash
# Package files (parallel)
glob: "package.json"
glob: "Gemfile"
glob: "requirements.txt"
glob: "go.mod"
glob: "Cargo.toml"

# Then grep for specific package
grep: '"package-name"' in results
```

## Search Result Processing

### Efficient Context Extraction
```bash
# Get function with full body (stop at next function)
grep -A 30 "def function_name" file.py | grep -B 1 "^def\|^class" | head -n -1

# Get class with methods list (not full implementation)
grep -A 50 "class ClassName" file.py | grep "def \|^class"

# Get imports section only
head -50 file.py | grep "import\|from.*import"
```

### Result Ranking Heuristics
1. **Exact matches** over partial matches
2. **Definition files** over usage files
3. **Core directories** (src, app, lib) over auxiliary
4. **Recent modifications** over old files (use ls -t)
5. **Smaller files** over large files (likely more specific)

## Performance Optimization Patterns

### Batch Operations
```bash
# Bad: Sequential searches
find . -name "*.py" -exec grep "pattern" {} \;

# Good: Parallel with xargs
find . -name "*.py" | xargs -P 4 grep "pattern"

# Better: Native parallel grep
rg "pattern" --include="*.py"
```

### Early Termination
```bash
# Stop after first match
rg "pattern" --include="*.py" -m 1

# Limit results
rg "pattern" --include="*.py" | head -20
```

### Search Caching
```bash
# Save common search results
auth_files=$(glob "**/auth*")
# Reuse for multiple patterns
echo "$auth_files" | xargs grep "login"
echo "$auth_files" | xargs grep "logout"
```