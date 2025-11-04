---
type: guidance
status: current
category: tools
focus_levels:
- implementation
tags:
- tools
---

# Tmux Sidecar

Create secondary tmux pane for bidirectional command execution.

## Identify Current Location
```bash
tmux display-message -p '#S:#I.#P'  # Returns session:window.pane
```

## Create Sidecar Pane
```bash
# Split current window vertically (pane below)
tmux split-window -v -t SESSION:WINDOW

# Split current window horizontally (pane beside)
tmux split-window -h -t SESSION:WINDOW
```

## Send Commands
```bash
# Send command to specific pane
tmux send-keys -t SESSION:WINDOW.PANE 'command here' C-m

# C-m = Enter key
# Without C-m, text appears but doesn't execute
```

## Shell Escaping
Use double quotes when command contains `!` (history expansion):
```bash
# Wrong - fails with history expansion
tmux send-keys -t SESSION:WINDOW.PANE 'echo "test!"' C-m

# Correct - use double quotes for commands with !
tmux send-keys -t SESSION:WINDOW.PANE "echo 'test!'" C-m
```

## Read Output
```bash
# Capture entire pane buffer
tmux capture-pane -t SESSION:WINDOW.PANE -p

# Capture last N lines
tmux capture-pane -t SESSION:WINDOW.PANE -p | tail -N

# Capture with line history
tmux capture-pane -t SESSION:WINDOW.PANE -p -S -N  # -S = start line offset
```

## List Panes/Windows
```bash
# List all panes in window
tmux list-panes -t SESSION:WINDOW -F '#P: #{pane_current_command}'

# List all windows in session
tmux list-windows -t SESSION -F '#I: #W (#{window_panes} panes)'

# List all sessions
tmux list-sessions
```

## Workflow Pattern
```bash
# 1. Find location
LOCATION=$(tmux display-message -p '#S:#I')

# 2. Create sidecar
tmux split-window -v -t $LOCATION

# 3. Send command
tmux send-keys -t ${LOCATION}.1 'your-command' C-m

# 4. Wait for completion
sleep N

# 5. Read output
tmux capture-pane -t ${LOCATION}.1 -p | tail -20
```

## Pane Numbering
- Panes numbered 0, 1, 2...
- New split increments from highest existing
- Use `.0` for original pane, `.1` for first split

## Common Use Cases
- Interactive REPLs (rails console, python, node)
- Long-running commands with monitoring
- Database clients
- Build watchers
- Log tailing

## Rails Console
```bash
# Start Rails console in sidecar pane
tmux send-keys -t SESSION:WINDOW.PANE 'bundle exec rails console' C-m

# Example: Full workflow for Rails console
LOCATION=$(tmux display-message -p '#S:#I')
tmux split-window -v -t $LOCATION
tmux send-keys -t ${LOCATION}.1 'bundle exec rails console' C-m
```