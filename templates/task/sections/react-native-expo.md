---
type: task-template
section: react-native-expo
description: React Native/Expo workflow - testing, Waydroid verification, PowerSync patterns
applies_to: react-native, expo, mobile, powersync
---

## Conventions Reference

**Project skills contain the conventions. Read them first:**
- `.claude/skills/react-native-dev/` - Component structure, test location, imports
- `.claude/skills/design-system/` - React Native Paper components, theming
- `.claude/skills/data-persistence/` - PowerSync patterns, CRUD operations
- `.claude/skills/ui-state-management/` - Zustand stores, MMKV persistence

**This template focuses on workflow and verification.**

---

## Testing Strategy

**Full test suite runs fast - always run the whole thing.**

```bash
# Run all tests
npm test -- --watchAll=false

# Watch mode during development
npm test -- --watch

# Type checking
npx tsc --noEmit

# Linting
npx expo lint
```

**Test file location:** `__tests__/` mirrors `src/` structure (Expo Router requirement).

---

## Verification Loops

### Loop 1: Unit/Component Tests (Jest)

```bash
# Run tests in watch mode during development
npm test -- --watch

# Verify all pass before proceeding
npm test -- --watchAll=false
```

**What to test:**
- Component rendering with different props
- User interactions (press, input)
- Hook behavior
- Business logic in operations/utils

**Wrap Paper components:**
```typescript
import { PaperProvider } from 'react-native-paper';

const renderWithPaper = (component: React.ReactElement) =>
  render(<PaperProvider>{component}</PaperProvider>);
```

### Loop 2: Visual Verification (Waydroid + ADB)

**Waydroid is the visual verification environment** (similar to Storybook for web).

```bash
# Ensure Waydroid is running
waydroid show-full-ui

# Connect ADB
adb connect 192.168.240.112:5555

# Port forwarding for local services
adb reverse tcp:8081 tcp:8081   # Metro
adb reverse tcp:54321 tcp:54321 # Supabase (if needed)
adb reverse tcp:8080 tcp:8080   # PowerSync (if needed)

# Start Metro
npm start

# Launch app
adb shell am start -n com.anonymous.projectalfalfa/.MainActivity

# Take screenshot for verification
adb exec-out screencap -p > /tmp/screen.png
```

**What to verify visually:**
- Component renders correctly
- Layout looks right
- Interactions work (tap, scroll)
- Theme/styling applied
- States visible (loading, empty, error)

### Loop 3: End-to-End Flow

**Verify the full user flow in Waydroid:**

1. Fresh app launch
2. User action sequence
3. Data persists correctly
4. Offline behavior (if applicable)

```bash
# Force stop and restart for clean state
adb shell am force-stop com.anonymous.projectalfalfa
adb shell am start -n com.anonymous.projectalfalfa/.MainActivity
```

---

## Pre-Handoff Checklist

Before marking task complete:

- [ ] **All tests pass:** `npm test -- --watchAll=false` exits 0
- [ ] **Types check:** `npx tsc --noEmit` exits 0
- [ ] **Lint clean:** `npx expo lint` exits 0
- [ ] **Visual verification:** Component looks correct in Waydroid
- [ ] **Interactions work:** Tested manually in app
- [ ] **No console errors:** Checked Metro bundler output

---

## Common Patterns

### Component Test Structure

```typescript
import { render, screen, fireEvent } from '@testing-library/react-native';
import { PaperProvider } from 'react-native-paper';
import { ComponentName } from '@/path/to/Component';

const renderWithPaper = (ui: React.ReactElement) =>
  render(<PaperProvider>{ui}</PaperProvider>);

describe('ComponentName', () => {
  it('renders correctly', () => {
    renderWithPaper(<ComponentName title="Test" />);
    expect(screen.getByText('Test')).toBeTruthy();
  });

  it('handles press', () => {
    const onPress = jest.fn();
    renderWithPaper(<ComponentName onPress={onPress} />);
    fireEvent.press(screen.getByRole('button'));
    expect(onPress).toHaveBeenCalled();
  });
});
```

### PowerSync Operation Test Structure

```typescript
// Mock the database
jest.mock('@/lib/powersync/client', () => ({
  db: {
    execute: jest.fn(),
    getAll: jest.fn(),
    getOptional: jest.fn(),
  },
}));

import { createTodo, getAllTodos } from '@/lib/powersync/operations';
import { db } from '@/lib/powersync/client';

describe('Todo operations', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('creates todo', async () => {
    (db.execute as jest.Mock).mockResolvedValue({ rowsAffected: 1 });

    const id = await createTodo('Test todo');

    expect(id).toBeDefined();
    expect(db.execute).toHaveBeenCalledWith(
      expect.stringContaining('INSERT'),
      expect.any(Array)
    );
  });
});
```

---

## Anti-patterns

**You MUST NEVER:**
- Skip Waydroid verification for UI changes
- Leave console errors unaddressed
- Commit with failing tests
- Skip type checking

**You MUST ALWAYS:**
- Run full test suite before handoff
- Verify visually in Waydroid for UI work
- Check Metro console for errors
- Follow patterns from project skills
