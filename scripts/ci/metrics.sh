#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# metrics.sh — Lightweight code metrics for the Dune Awakening Companion App
#
# Usage:
#   bash scripts/ci/metrics.sh            # Print report to stdout
#   bash scripts/ci/metrics.sh --json     # Output JSON to build/metrics.json
#
# What it measures:
#   1. Lines of code (Dart source, excluding generated files)
#   2. Largest files (potential complexity hotspots)
#   3. TODO/FIXME/HACK counts (technical debt indicators)
#   4. Test-to-source ratio
#   5. File count by directory
#
# This replaces the discontinued dart_code_metrics package with a
# zero-dependency solution suitable for open-source projects.
# ---------------------------------------------------------------------------
set -euo pipefail

LIB_DIR="lib"
TEST_DIR="test"
JSON_MODE=false
OUTPUT_DIR="build"

if [[ "${1:-}" == "--json" ]]; then
  JSON_MODE=true
  mkdir -p "$OUTPUT_DIR"
fi

# ---------------------------------------------------------------------------
# 1. Lines of code (excluding generated .g.dart and .freezed.dart)
# ---------------------------------------------------------------------------
count_loc() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    echo 0
    return
  fi
  find "$dir" -name '*.dart' \
    ! -name '*.g.dart' \
    ! -name '*.freezed.dart' \
    -exec cat {} + 2>/dev/null | wc -l | tr -d '[:space:]'
}

LIB_LOC=$(count_loc "$LIB_DIR")
TEST_LOC=$(count_loc "$TEST_DIR")
TOTAL_LOC=$(( LIB_LOC + TEST_LOC ))

# ---------------------------------------------------------------------------
# 2. File counts
# ---------------------------------------------------------------------------
count_files() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    echo 0
    return
  fi
  find "$dir" -name '*.dart' \
    ! -name '*.g.dart' \
    ! -name '*.freezed.dart' | wc -l | tr -d '[:space:]'
}

LIB_FILES=$(count_files "$LIB_DIR")
TEST_FILES=$(count_files "$TEST_DIR")

# ---------------------------------------------------------------------------
# 3. Test-to-source ratio
# ---------------------------------------------------------------------------
if [[ "$LIB_LOC" -gt 0 ]]; then
  TEST_RATIO=$(python3 -c "print(round($TEST_LOC / $LIB_LOC * 100, 1))")
else
  TEST_RATIO="0.0"
fi

# ---------------------------------------------------------------------------
# 4. Largest files (top 10 by line count, excluding generated)
# ---------------------------------------------------------------------------
LARGEST_FILES=""
if [[ -d "$LIB_DIR" ]]; then
  LARGEST_FILES=$(find "$LIB_DIR" -name '*.dart' \
    ! -name '*.g.dart' \
    ! -name '*.freezed.dart' \
    -exec wc -l {} + 2>/dev/null \
    | sort -rn \
    | head -11 \
    | tail -10)
fi

# ---------------------------------------------------------------------------
# 5. TODO/FIXME/HACK counts
# ---------------------------------------------------------------------------
count_markers() {
  local marker="$1"
  local count=0
  if [[ -d "$LIB_DIR" ]]; then
    count=$(grep -ri "$marker" "$LIB_DIR" --include='*.dart' \
      --exclude='*.g.dart' --exclude='*.freezed.dart' 2>/dev/null | wc -l || echo 0)
  fi
  echo "$count" | tr -d '[:space:]'
}

TODO_COUNT=$(count_markers "TODO")
FIXME_COUNT=$(count_markers "FIXME")
HACK_COUNT=$(count_markers "HACK")

# ---------------------------------------------------------------------------
# 6. Files per feature directory
# ---------------------------------------------------------------------------
FEATURE_BREAKDOWN=""
if [[ -d "$LIB_DIR/features" ]]; then
  FEATURE_BREAKDOWN=$(for d in "$LIB_DIR"/features/*/; do
    name=$(basename "$d")
    count=$(find "$d" -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart' | wc -l | tr -d '[:space:]')
    echo "  $name: $count files"
  done)
fi

CORE_FILES=0
if [[ -d "$LIB_DIR/core" ]]; then
  CORE_FILES=$(find "$LIB_DIR/core" -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart' | wc -l | tr -d '[:space:]')
fi

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------
if $JSON_MODE; then
  cat > "$OUTPUT_DIR/metrics.json" <<METRICS_JSON
{
  "timestamp": "$(date -Iseconds)",
  "lines_of_code": {
    "lib": $LIB_LOC,
    "test": $TEST_LOC,
    "total": $TOTAL_LOC
  },
  "file_counts": {
    "lib": $LIB_FILES,
    "test": $TEST_FILES
  },
  "test_to_source_ratio_pct": $TEST_RATIO,
  "debt_markers": {
    "todo": $TODO_COUNT,
    "fixme": $FIXME_COUNT,
    "hack": $HACK_COUNT
  }
}
METRICS_JSON
  echo "Metrics written to $OUTPUT_DIR/metrics.json"
else
  echo "================================================================"
  echo "  Code Metrics Report"
  echo "================================================================"
  echo ""
  echo "Lines of Code (excluding generated files):"
  echo "  lib/:   $LIB_LOC"
  echo "  test/:  $TEST_LOC"
  echo "  total:  $TOTAL_LOC"
  echo ""
  echo "File Counts:"
  echo "  lib/:   $LIB_FILES"
  echo "  test/:  $TEST_FILES"
  echo ""
  echo "Test-to-Source Ratio: ${TEST_RATIO}%"
  echo ""
  echo "Technical Debt Markers:"
  echo "  TODO:   $TODO_COUNT"
  echo "  FIXME:  $FIXME_COUNT"
  echo "  HACK:   $HACK_COUNT"
  echo ""
  echo "Feature Breakdown:"
  echo "$FEATURE_BREAKDOWN"
  echo "  core: $CORE_FILES files"
  echo ""
  echo "Largest Files (by line count):"
  echo "$LARGEST_FILES"
  echo ""
  echo "================================================================"
fi
