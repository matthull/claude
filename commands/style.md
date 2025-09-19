# /style

Quick style switching command for rapid context optimization.

## Usage
- `/style minimal` - Ultra-lightweight (~2k tokens)
- `/style ultrathink` - Maximum efficiency mode (~3k tokens)
- `/style focused` - Task-optimized (~5k tokens)
- `/style standard` - Balanced approach (~8k tokens)
- `/style default` - Return to Claude default
- `/style list` - Show available styles

## Implementation

Delegates to appropriate output-style command or provides quick switching.

### Quick Switch Logic
```bash
case $1 in
  minimal|ultrathink|focused|standard)
    /output-style $1
    ;;
  default)
    /output-style:reset
    ;;
  list)
    ls ~/.claude/output-styles/templates/
    ;;
  *)
    echo "Usage: /style [minimal|ultrathink|focused|standard|default|list]"
    ;;
esac
```

## Style Descriptions

### minimal
- Bare essentials only
- For quick queries and calculations
- 83% token reduction

### ultrathink
- Maximum efficiency with foundation bundle
- Single-line responses, emoji status
- 75% token reduction

### focused
- Task-specific tool loading
- Professional development mode
- 58% token reduction

### standard
- Balanced features and efficiency
- General development work
- 33% token reduction

## Context-Aware Recommendations

The command should suggest appropriate styles based on task:

- **Planning/Research**: standard or default
- **Implementation**: focused or ultrathink
- **Quick fixes**: minimal or ultrathink
- **Complex debugging**: standard or default
- **Refactoring**: ultrathink

## Examples

```bash
# Starting a new feature
/style standard

# Rapid implementation phase
/style ultrathink

# Quick calculation
/style minimal

# Back to full features
/style default
```