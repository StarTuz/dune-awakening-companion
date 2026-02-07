#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# perf_baseline.sh — Capture and compare performance baselines
#
# Usage:
#   bash scripts/ci/perf_baseline.sh          # Run benchmarks & compare
#   bash scripts/ci/perf_baseline.sh --save   # Save current run as baseline
#
# What it measures:
#   1. flutter analyze   — static analysis wall-clock time
#   2. flutter test      — test suite wall-clock time
#   3. flutter build     — debug build wall-clock time
#   4. Dart package size — total dependency footprint
#
# The script stores baselines in build/perf_baseline.json.
# When run without --save it compares current values to the saved baseline
# and fails if any metric regresses beyond the configured threshold.
# ---------------------------------------------------------------------------
set -euo pipefail

BASELINE_DIR="build"
BASELINE_FILE="${BASELINE_DIR}/perf_baseline.json"
RESULTS_FILE="${BASELINE_DIR}/perf_results.json"
REGRESSION_THRESHOLD_PCT="${PERF_REGRESSION_THRESHOLD:-25}"   # allow up to 25% slower
SAVE_MODE=false

if [[ "${1:-}" == "--save" ]]; then
  SAVE_MODE=true
fi

mkdir -p "$BASELINE_DIR"

# ---------------------------------------------------------------------------
# Helper: time a command and return elapsed seconds
# ---------------------------------------------------------------------------
time_cmd() {
  local label="$1"
  shift
  local start end elapsed
  start=$(date +%s%3N)
  if ! "$@" > /dev/null 2>&1; then
    echo "Error: Command failed for '$label'" >&2
    exit 1
  fi
  end=$(date +%s%3N)
  elapsed=$(( end - start ))
  echo "$elapsed"
}

echo "==> Running performance benchmarks"

# 1. Static analysis time
echo "  [1/4] flutter analyze"
ANALYZE_MS=$(time_cmd "analyze" flutter analyze)
echo "         ${ANALYZE_MS}ms"

# 2. Test suite time
echo "  [2/4] flutter test"
TEST_MS=$(time_cmd "test" flutter test)
echo "         ${TEST_MS}ms"

# 3. Debug build time (Linux)
echo "  [3/4] flutter build linux --debug"
BUILD_MS=$(time_cmd "build" flutter build linux --debug)
echo "         ${BUILD_MS}ms"

# 4. Package size (pub cache footprint via dart pub deps)
echo "  [4/4] dependency count"
DEP_COUNT=$(dart pub deps --no-dev 2>/dev/null | wc -l || echo 0)
DEP_COUNT=$(echo "$DEP_COUNT" | tr -d '[:space:]')
echo "         ${DEP_COUNT} lines"

# ---------------------------------------------------------------------------
# Write current results
# ---------------------------------------------------------------------------
cat > "$RESULTS_FILE" <<RESULTS_JSON
{
  "timestamp": "$(date -Iseconds)",
  "analyze_ms": ${ANALYZE_MS},
  "test_ms": ${TEST_MS},
  "build_ms": ${BUILD_MS},
  "dep_count": ${DEP_COUNT}
}
RESULTS_JSON

echo ""
echo "==> Results written to ${RESULTS_FILE}"

# ---------------------------------------------------------------------------
# Save mode: persist as baseline
# ---------------------------------------------------------------------------
if $SAVE_MODE; then
  cp "$RESULTS_FILE" "$BASELINE_FILE"
  echo "==> Baseline saved to ${BASELINE_FILE}"
  exit 0
fi

# ---------------------------------------------------------------------------
# Compare mode: check for regressions
# ---------------------------------------------------------------------------
if [[ ! -f "$BASELINE_FILE" ]]; then
  echo "==> No baseline found at ${BASELINE_FILE}."
  echo "    Run with --save first to establish a baseline."
  echo "    Skipping regression check."
  exit 0
fi

echo "==> Comparing against baseline (threshold: ${REGRESSION_THRESHOLD_PCT}% regression allowed)"

# Parse baseline values
BASELINE_ANALYZE=$(python3 -c "import json; d=json.load(open('${BASELINE_FILE}')); print(d['analyze_ms'])")
BASELINE_TEST=$(python3 -c "import json; d=json.load(open('${BASELINE_FILE}')); print(d['test_ms'])")
BASELINE_BUILD=$(python3 -c "import json; d=json.load(open('${BASELINE_FILE}')); print(d['build_ms'])")
BASELINE_DEPS=$(python3 -c "import json; d=json.load(open('${BASELINE_FILE}')); print(d['dep_count'])")

FAILED=false

check_regression() {
  local name="$1"
  local baseline="$2"
  local current="$3"
  local threshold="$REGRESSION_THRESHOLD_PCT"

  if [[ "$baseline" -eq 0 ]]; then
    echo "  [SKIP] $name — baseline is 0, cannot compare"
    return
  fi

  local delta=$(( current - baseline ))
  local pct_change
  pct_change=$(python3 -c "print(round(($delta / $baseline) * 100, 1))")

  if python3 -c "exit(0 if $pct_change > $threshold else 1)" 2>/dev/null; then
    echo "  [FAIL] $name: ${current} vs baseline ${baseline} (+${pct_change}% — exceeds ${threshold}%)"
    FAILED=true
  else
    echo "  [ OK ] $name: ${current} vs baseline ${baseline} (${pct_change}%)"
  fi
}

check_regression "analyze_ms" "$BASELINE_ANALYZE" "$ANALYZE_MS"
check_regression "test_ms"    "$BASELINE_TEST"    "$TEST_MS"
check_regression "build_ms"   "$BASELINE_BUILD"   "$BUILD_MS"
check_regression "dep_count"  "$BASELINE_DEPS"    "$DEP_COUNT"

echo ""

if $FAILED; then
  echo "==> PERFORMANCE REGRESSION DETECTED"
  echo "    Review the metrics above. If the regression is expected"
  echo "    (e.g., new feature adds deps), re-run with --save to update."
  exit 1
else
  echo "==> All performance checks passed."
fi
