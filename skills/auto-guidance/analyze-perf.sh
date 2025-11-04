#!/bin/bash
# Analyze auto-guidance performance logs
# Usage: ./analyze-perf.sh [log_file]

set -e

PERF_LOG="${1:-/tmp/claude-auto-guidance-perf.log}"

if [ ! -f "$PERF_LOG" ]; then
  echo "❌ Performance log not found: $PERF_LOG"
  echo "   Make sure performance_tracking is enabled in config.yaml"
  exit 1
fi

echo "=== Auto-Guidance Performance Analysis ==="
echo "Log file: $PERF_LOG"
echo

# Count operations
total_ops=$(wc -l < "$PERF_LOG")
echo "Total operations: $total_ops"
echo

# Index build time
if grep -q "index_build" "$PERF_LOG"; then
  index_time=$(awk -F',' '$2=="index_build" {print $5}' "$PERF_LOG" | head -1)
  index_count=$(awk -F',' '$2=="index_build" {print $4}' "$PERF_LOG" | head -1)
  echo "📚 Index Build"
  echo "   Time: ${index_time}ms"
  echo "   Files indexed: $index_count"
  echo
fi

# Pattern matching stats
pattern_matches=$(grep ",pattern_match," "$PERF_LOG" | wc -l)
if [ "$pattern_matches" -gt 0 ]; then
  avg_pattern_time=$(awk -F',' '$2=="pattern_match" {sum+=$5; count++} END {print int(sum/count)}' "$PERF_LOG")
  max_pattern_time=$(awk -F',' '$2=="pattern_match" {print $5}' "$PERF_LOG" | sort -rn | head -1)
  matches_found=$(awk -F',' '$2=="pattern_match" && $6=="1" {count++} END {print count}' "$PERF_LOG")

  echo "🔍 Pattern Matching"
  echo "   Total checks: $pattern_matches"
  echo "   Matches found: $matches_found"
  echo "   Average time: ${avg_pattern_time}ms"
  echo "   Max time: ${max_pattern_time}ms"
  echo
fi

# Guidance loading stats
guidance_loads=$(grep ",guidance_load," "$PERF_LOG" | wc -l)
if [ "$guidance_loads" -gt 0 ]; then
  avg_load_time=$(awk -F',' '$2=="guidance_load" {sum+=$5; count++} END {print int(sum/count)}' "$PERF_LOG")
  max_load_time=$(awk -F',' '$2=="guidance_load" {print $5}' "$PERF_LOG" | sort -rn | head -1)

  echo "📖 Guidance Loading"
  echo "   Total loaded: $guidance_loads"
  echo "   Average time: ${avg_load_time}ms"
  echo "   Max time: ${max_load_time}ms"
  echo
fi

# Most loaded guidance files
echo "📊 Most Loaded Guidance Files"
awk -F',' '$2=="guidance_load" {print $3}' "$PERF_LOG" | sort | uniq -c | sort -rn | head -5 | while read count file; do
  echo "   $count × $file"
done
echo

# Slowest operations
echo "⚠️  Slowest Operations (Top 5)"
sort -t',' -k5 -rn "$PERF_LOG" | head -5 | while IFS=',' read timestamp op file duration matched loaded; do
  echo "   ${duration}ms - $op - $file"
done
echo

# Operations by file type
echo "📁 Operations by File Type"
awk -F',' '$3 != "-" {
  split($3,a,".");
  ext = (length(a) > 1) ? a[length(a)] : "no_ext";
  count[ext]++
}
END {
  for (ext in count) {
    printf "   .%-10s %d\n", ext, count[ext]
  }
}' "$PERF_LOG" | sort -k2 -rn | head -10
echo

# Performance warnings
echo "⚡ Performance Warnings"
slow_patterns=$(awk -F',' '$2=="pattern_match" && $5>50 {count++} END {print count+0}' "$PERF_LOG")
slow_loads=$(awk -F',' '$2=="guidance_load" && $5>200 {count++} END {print count+0}' "$PERF_LOG")

if [ "$slow_patterns" -gt 0 ]; then
  echo "   ⚠️  $slow_patterns pattern matching operations >50ms"
fi
if [ "$slow_loads" -gt 0 ]; then
  echo "   ⚠️  $slow_loads guidance loading operations >200ms"
fi
if [ "$slow_patterns" -eq 0 ] && [ "$slow_loads" -eq 0 ]; then
  echo "   ✅ No performance warnings"
fi
echo

# Overall impact estimate
if [ "$pattern_matches" -gt 0 ]; then
  total_pattern_time=$(awk -F',' '$2=="pattern_match" {sum+=$5} END {print int(sum)}' "$PERF_LOG")
  total_load_time=$(awk -F',' '$2=="guidance_load" {sum+=$5} END {print int(sum)}' "$PERF_LOG")
  total_overhead=$((total_pattern_time + total_load_time))

  echo "📈 Overall Impact"
  echo "   Total overhead: ${total_overhead}ms across $total_ops operations"
  echo "   Average per operation: $((total_overhead / total_ops))ms"
  echo
fi

echo "=== Analysis Complete ==="
