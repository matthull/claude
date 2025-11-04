# Auto-Guidance Performance Design

## Performance Concerns

The auto-guidance skill will be evaluated on **every file-related tool call** (Read, Edit, Write). This means:
- Potentially hundreds of evaluations per session
- Must be fast enough to not slow down file operations
- Need to measure actual impact, not guess

## Performance Tracking Strategy

### Metrics to Track

1. **Index Build Time** (once per session)
   - Time to scan guidance directories
   - Time to parse frontmatter from all files
   - Number of files indexed
   - Total index size

2. **Pattern Matching Time** (per file operation)
   - Time to match file path against patterns
   - Number of patterns checked
   - Number of matches found

3. **Guidance Loading Time** (when match found)
   - Time to read guidance file content
   - Size of guidance loaded
   - Number of @-references resolved

4. **Session State Management** (per operation)
   - Time to check if already loaded
   - Memory usage of loaded guidance tracking

### Performance Measurement Implementation

**Option 1: Bash Timing (Recommended)**
```bash
# Track timing in temp file
PERF_LOG="/tmp/claude-auto-guidance-perf-${session_id}.log"

# Before operation
start_time=$(date +%s%3N)  # milliseconds

# ... operation ...

# After operation
end_time=$(date +%s%3N)
duration=$((end_time - start_time))
echo "${operation},${duration}ms" >> $PERF_LOG
```

**Option 2: Claude's Working Memory**
- Track timing in conversation
- Report periodically: "Auto-guidance timing: 15ms avg over 20 operations"
- Less precise but simpler

### Performance Budgets

**Target Performance:**
- Index build: <200ms (once per session)
- Pattern matching: <10ms per file operation
- Guidance loading: <50ms per guidance file
- Session check: <1ms

**Acceptable Performance:**
- Index build: <500ms
- Pattern matching: <25ms
- Guidance loading: <100ms
- Session check: <5ms

**Unacceptable Performance:**
- Any operation >500ms
- Pattern matching >50ms
- Cumulative slowdown >10% on file operations

### Optimization Strategies

**If Performance Issues Detected:**

1. **Index Caching**
   - Build index once per session, cache in memory
   - Don't rescan filesystem on every file operation
   - Implementation: Store index in Claude's conversation memory

2. **Pattern Matching Optimization**
   - Pre-compile patterns into efficient structure
   - Early termination on first match
   - Group patterns by common prefixes
   - Use simple string matching before full glob

3. **Lazy Loading**
   - Don't load guidance content until actually used
   - Load only relevant sections, not entire file
   - Stream large guidance files

4. **Smart Triggers**
   - Disable auto-guidance for certain file types (e.g., images, binaries)
   - Skip pattern matching for very long file paths
   - Throttle: only check every Nth file operation

### Performance Logging Format

**Log File Structure:**
```
# /tmp/claude-auto-guidance-perf-{session}.log
timestamp,operation,file_path,duration_ms,matched,loaded
2025-10-28T12:00:00,index_build,-,150,57,0
2025-10-28T12:00:01,pattern_match,app/controllers/users_controller.rb,5,1,1
2025-10-28T12:00:01,guidance_load,rails/crud-controllers.md,45,-,-
2025-10-28T12:00:02,pattern_match,app/models/user.rb,3,1,0
2025-10-28T12:00:02,pattern_match,spec/models/user_spec.rb,4,2,1
```

**Analysis Commands:**
```bash
# Average pattern matching time
awk -F',' '$2=="pattern_match" {sum+=$5; count++} END {print sum/count "ms"}' $PERF_LOG

# Total guidance files loaded
grep ",guidance_load," $PERF_LOG | wc -l

# Slowest operations
sort -t',' -k5 -rn $PERF_LOG | head -10

# Operations by file type
awk -F',' '{split($3,a,"."); print a[length(a)]}' $PERF_LOG | sort | uniq -c
```

## Implementation in Skill

### Skill Structure with Performance Tracking

```markdown
# Auto-Guidance Skill

## Session State
Track in working memory:
- `guidanceIndex`: Built once per session
- `loadedGuidance`: Set of loaded file paths
- `perfMetrics`: Performance measurements

## On First Invocation
1. Start timer
2. Build guidance index (scan + parse frontmatter)
3. Record timing: "Index built in {duration}ms ({count} files)"
4. Cache index in conversation memory

## On Every File Operation
1. Start timer
2. Extract file path from tool call
3. Check patterns (use cached index)
4. Record timing
5. If match found and not loaded:
   - Load guidance
   - Add to loadedGuidance
   - Report: "📚 Loaded {file} ({duration}ms)"
6. If no match or already loaded:
   - Skip silently (or report timing if verbose)

## Performance Reporting
Every 20 operations, report summary:
"Auto-guidance stats: 20 checks, avg 8ms, 3 guidance files loaded"
```

### Configuration Options

```yaml
# ~/.claude/skills/auto-guidance/config.yaml
enabled: true
performance_tracking: true
performance_log: "/tmp/claude-auto-guidance-perf.log"
verbose_timing: false  # Report timing on every operation
report_interval: 20    # Report summary every N operations
max_pattern_time_ms: 50  # Warn if pattern matching exceeds this
```

## Success Criteria

**Phase 1: Measurement**
- Performance logging implemented
- Can measure actual impact on file operations
- Baseline established (without auto-guidance vs with)

**Phase 2: Optimization (if needed)**
- Identify bottlenecks from logs
- Implement targeted optimizations
- Re-measure to confirm improvement

**Phase 3: Production Ready**
- Pattern matching <25ms average
- Total overhead <10% on file operations
- No user-perceptible slowdown
- Performance degrades gracefully with large guidance libraries

## Testing Performance

### Test Scenarios

1. **Cold Start** (first file operation in session)
   - Measures index build time
   - Expected: 150-300ms for ~60 files

2. **Hot Path** (subsequent file operations)
   - Measures pattern matching + session check
   - Expected: 5-15ms per operation

3. **Guidance Loading** (when match found)
   - Measures file read + content loading
   - Expected: 30-80ms per guidance file

4. **High Volume** (100+ file operations)
   - Measures cumulative overhead
   - Expected: <10% total time increase

### Test Commands

```bash
# Generate test workload
time for i in {1..100}; do
  # Trigger auto-guidance on various files
  echo "Reading app/controllers/users_controller.rb"
  echo "Reading app/models/user.rb"
  echo "Reading spec/models/user_spec.rb"
done

# Analyze performance log
bash ~/.claude/skills/auto-guidance/analyze-perf.sh
```

## Monitoring & Alerts

**Warning Conditions:**
- Pattern matching >50ms
- Index build >500ms
- Guidance loading >200ms
- Total overhead >20%

**When Warnings Occur:**
- Log details to debug log
- Consider disabling auto-guidance for session
- File bug report with performance data

## Future Optimizations

**Not Implemented Initially (YAGNI):**
- Pre-built index file (persistent across sessions)
- Binary search for pattern matching
- Parallel guidance loading
- Guidance content compression
- Smart caching with TTL

**Implement Only If Needed:**
- Performance logs show actual bottleneck
- User reports perceptible slowdown
- Guidance library grows significantly (>200 files)
