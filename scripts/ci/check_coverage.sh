#!/usr/bin/env bash
set -euo pipefail

LCOV_FILE="${1:-coverage/lcov.info}"
THRESHOLD="${COVERAGE_THRESHOLD:-15}"

if [[ ! -f "$LCOV_FILE" ]]; then
  echo "Coverage file not found: $LCOV_FILE"
  exit 1
fi

awk -F: -v threshold="$THRESHOLD" '
  /^LF:/ { lf += $2 }
  /^LH:/ { lh += $2 }
  END {
    if (lf == 0) {
      printf("No lines found in coverage report\n");
      exit 1
    }
    pct = (lh / lf) * 100
    printf("Coverage: %.2f%% (threshold: %s%%)\n", pct, threshold)
    if (pct < threshold) {
      exit 1
    }
  }
' "$LCOV_FILE"
