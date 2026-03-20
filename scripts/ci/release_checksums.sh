#!/usr/bin/env bash
set -euo pipefail

ARTIFACT_DIR="${1:-artifacts}"
OUTPUT_FILE="${2:-checksums.txt}"

if [[ ! -d "$ARTIFACT_DIR" ]]; then
  echo "Artifact directory not found: $ARTIFACT_DIR" >&2
  exit 1
fi

find "$ARTIFACT_DIR" -type f \( -name '*.tar.gz' -o -name '*.zip' -o -name '*.apk' -o -name '*.json' \) \
  -exec sha256sum {} \; | sort > "$OUTPUT_FILE"

echo "Wrote checksums to $OUTPUT_FILE"
