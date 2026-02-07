#!/usr/bin/env bash
set -euo pipefail

export COVERAGE_THRESHOLD="${COVERAGE_THRESHOLD:-15}"

echo "==> Validate GitHub Actions workflows"
if command -v actionlint &>/dev/null; then
  actionlint .github/workflows/*.yml
  echo "    Workflows valid."
else
  echo "    actionlint not installed — skipping (install: go install github.com/rhysd/actionlint/cmd/actionlint@latest)"
fi

echo "==> Flutter version"
flutter --version

echo "==> Get dependencies"
flutter pub get

echo "==> Generate code"
dart run build_runner build --delete-conflicting-outputs

echo "==> Check formatting"
dart format --set-exit-if-changed .

echo "==> Static analysis"
flutter analyze

echo "==> Run tests with coverage"
flutter test --coverage

echo "==> Enforce coverage threshold (${COVERAGE_THRESHOLD}%)"
bash scripts/ci/check_coverage.sh

echo "==> Build Linux (debug)"
flutter build linux --debug

echo ""
echo "==> All local CI checks passed!"
