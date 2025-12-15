---
name: waydroid-adb
description: Control Waydroid Android emulator via ADB for Expo/React Native development. This skill should be used when needing to take screenshots of Waydroid, verify app rendering, install APKs, or interact with the Android emulator. Triggers on tasks involving Android emulator verification, mobile app visual testing, or Waydroid troubleshooting.
---

# Waydroid ADB Control

Tools and workflows for controlling Waydroid Android emulator via ADB for Expo/React Native development.

## Session Startup

**Always run the startup script first:**
```bash
/home/matt/code/project-alfalfa/scripts/waydroid-dev-start.sh
```

This handles network config, ADB connection, and port forwarding (Metro 8081, Supabase 54321, PowerSync 8080). Takes ~15 seconds.

## Development Build vs Expo Go

**We use a development build** (custom native app) instead of Expo Go because:
- MMKV, PowerSync, and other native modules require custom native code
- Dev builds support all native modules after one-time compile
- Hot reload still works normally via Metro

### First-Time Build
```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
npx expo prebuild --platform android  # Generate android/ folder
npx expo run:android                   # Build + install (~5-10 min)
```

### Subsequent Development
After dev build is installed, start the full dev environment:
```bash
npm run dev
# Starts Supabase + PowerSync + Metro
# App already installed - hot reload works
```

Or start services separately:
```bash
npm run dev:backend  # Supabase + PowerSync only
npm start            # Metro only (if backend already running)
```

### Rebuild Required When
- Adding new native dependencies
- Changing app.json/app.config.js native settings
- After `npm install` of packages with native code

## Common Operations

### Take Screenshot
```bash
adb exec-out screencap -p > /tmp/screen.png
```
Then use Read tool to view the image.

### Check Status
```bash
waydroid status  # Container state
adb devices      # ADB connection (should show "device")
```

### Launch Dev Build App
```bash
# Launch by package name (dev build)
adb shell am start -n com.anonymous.projectalfalfa/.MainActivity
```

### Force Restart App
```bash
adb shell am force-stop com.anonymous.projectalfalfa
adb shell am start -n com.anonymous.projectalfalfa/.MainActivity
```

### Install APK
```bash
adb install /path/to/app.apk
```

### View Logs (for debugging)
```bash
adb logcat -d | grep -iE "react|expo|error" | tail -30
```

### Toggle Dark Mode
```bash
adb shell cmd uimode night yes   # Enable dark mode
adb shell cmd uimode night no    # Disable dark mode
```

## UI Interaction (USE HELPER SCRIPTS)

**ALWAYS use helper scripts for UI interaction - they can be whitelisted for auto-approval.**

### Tap a Button by Label
```bash
~/.claude/skills/waydroid-adb/scripts/tap-button.sh "Add Todo"
~/.claude/skills/waydroid-adb/scripts/tap-button.sh "Clear All"
~/.claude/skills/waydroid-adb/scripts/tap-button.sh "Cycle Theme"
```

### Get UI Text Values
```bash
~/.claude/skills/waydroid-adb/scripts/get-ui-text.sh "Todos:"    # Returns "Todos: 5"
~/.claude/skills/waydroid-adb/scripts/get-ui-text.sh "DB:"       # Returns "DB: Ready"
~/.claude/skills/waydroid-adb/scripts/get-ui-text.sh "Connected" # Returns "Connected"
```

### Dump UI Hierarchy
```bash
~/.claude/skills/waydroid-adb/scripts/ui-dump.sh                 # Full dump
~/.claude/skills/waydroid-adb/scripts/ui-dump.sh "Add Todo"      # Filter for pattern
```

### Launch/Restart App
```bash
~/.claude/skills/waydroid-adb/scripts/app-launch.sh              # Launch app
~/.claude/skills/waydroid-adb/scripts/app-launch.sh --restart    # Force restart
```

### Take Screenshot
```bash
~/.claude/skills/waydroid-adb/scripts/screenshot.sh              # Save to /tmp/waydroid_screen.png
~/.claude/skills/waydroid-adb/scripts/screenshot.sh /tmp/test.png
```

### React Native Specifics
- **Buttons**: Use `content-desc` (set via `accessibilityLabel` prop)
- **Text**: Use `text` attribute
- **Views with testID**: Check `resource-id` (may have package prefix)

### Manual ADB Commands (fallback)
```bash
adb shell input text "hello"              # Type text (no spaces)
adb shell input keyevent KEYCODE_BACK     # Back button
adb shell input keyevent KEYCODE_ENTER    # Enter key
adb shell input swipe 500 1000 500 500    # Swipe up (x1 y1 x2 y2)
```

## Workflows

### Verify App Rendering (Dev Build)
1. Run startup script (if not already done)
2. Start Metro: `npm start`
3. Launch app: `adb shell am start -n com.anonymous.projectalfalfa/.MainActivity`
4. Take screenshot: `adb exec-out screencap -p > /tmp/screen.png`
5. View with Read tool

### Hot Reload Verification
1. Take screenshot
2. Make code change and save
3. Wait 3-4 seconds
4. Take another screenshot
5. Compare to verify change reflected

### Debug Loading Issues
1. Check Metro is running: `ss -tlnp | grep 8081`
2. Check adb reverse: `adb reverse --list`
3. Check logs: `adb logcat -d | grep -iE "react|expo|error" | tail -30`
4. Force restart app and retry

### Test Persistence (State Survives Restart)
1. Take screenshot showing initial state
2. Change state in app (e.g., theme preference)
3. Take screenshot showing changed state
4. Force quit: `adb shell am force-stop com.anonymous.projectalfalfa`
5. Relaunch app
6. Take screenshot - state should be preserved

## Scripts

All scripts are in `~/.claude/skills/waydroid-adb/scripts/` and can be whitelisted.

| Script | Purpose | Example |
|--------|---------|---------|
| `screenshot.sh` | Take screenshot | `screenshot.sh /tmp/test.png` |
| `status.sh` | Full status check | `status.sh` |
| `tap-button.sh` | Tap button by label | `tap-button.sh "Add Todo"` |
| `get-ui-text.sh` | Get text from UI | `get-ui-text.sh "Todos:"` |
| `ui-dump.sh` | Dump/filter UI hierarchy | `ui-dump.sh "pattern"` |
| `app-launch.sh` | Launch/restart app | `app-launch.sh --restart` |

## Reference

For detailed setup, troubleshooting, and known issues, see:
- Project docs: `/home/matt/code/project-alfalfa/docs/waydroid-setup.md`
- Skill reference: `references/setup-guide.md`
