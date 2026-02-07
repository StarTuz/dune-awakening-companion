#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="${1:-build}"
OUTPUT_FILE="${OUTPUT_DIR}/deps_outdated.json"

mkdir -p "$OUTPUT_DIR"

dart pub outdated --json > "$OUTPUT_FILE"

echo "Dependency report written to ${OUTPUT_FILE}"
