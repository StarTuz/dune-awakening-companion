#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="${1:-build}"
OUTPUT_FILE="${OUTPUT_DIR}/sbom.json"

mkdir -p "$OUTPUT_DIR"

dart pub deps --json > "$OUTPUT_FILE"

echo "SBOM written to ${OUTPUT_FILE}"
