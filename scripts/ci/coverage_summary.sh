#!/usr/bin/env bash
set -euo pipefail

LCOV_FILE="${1:-coverage/lcov.info}"

if [[ ! -f "$LCOV_FILE" ]]; then
  echo "Coverage file not found: $LCOV_FILE"
  exit 1
fi

awk -F: '
  /^LF:/ { lf += $2 }
  /^LH:/ { lh += $2 }
  END {
    if (lf == 0) {
      printf("## Coverage\n\nNo lines found.\n")
      exit 0
    }
    pct = (lh / lf) * 100
    printf("## Coverage\n\n| Lines Found | Lines Hit | Coverage |\n")
    printf("|:-----------:|:---------:|:--------:|\n")
    printf("| %d | %d | **%.2f%%** |\n", lf, lh, pct)
  }
' "$LCOV_FILE"
