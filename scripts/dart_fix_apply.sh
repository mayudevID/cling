#!/usr/bin/env bash
set -euo pipefail

# Run from the repository root regardless of the invoking directory.
cd "$(dirname "$0")/.."

# CI runners install Flutter directly; developers can continue using FVM.
DART=(dart)
if [[ "${CI:-false}" != "true" ]] && command -v fvm >/dev/null 2>&1; then
  DART=(fvm dart)
fi

CAFFEINATE_PID=""
if [[ "${CI:-false}" != "true" ]] && command -v caffeinate >/dev/null 2>&1; then
  caffeinate -dimsu &
  CAFFEINATE_PID=$!
fi

cleanup() {
  if [[ -n "$CAFFEINATE_PID" ]]; then
    kill -TERM "$CAFFEINATE_PID" 2>/dev/null || true
    wait "$CAFFEINATE_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT
trap 'exit 130' INT TERM

run_step() {
  printf '\n🔧 Running:'
  printf ' %q' "$@"
  printf '\n'
  "$@"
  if [[ "${CI:-false}" != "true" ]]; then
    sleep 0.5
  fi
}

run_fix_code() {
  run_step "${DART[@]}" fix --apply "--code=$1"
}

echo "🚀 Applying Dart fixes and formatting..."

LINT_FIX_CODES=(
  unnecessary_const
  unnecessary_late
  unnecessary_string_interpolations
  sized_box_for_whitespace
  prefer_final_in_for_each
  prefer_const_constructors
  prefer_const_constructors_in_immutables
  prefer_const_literals_to_create_immutables
  prefer_const_declarations
  avoid_unnecessary_containers
  avoid_redundant_argument_values
  prefer_final_locals
  prefer_final_fields
  prefer_spread_collections
  prefer_collection_literals
  prefer_is_empty
  prefer_is_not_empty
  prefer_contains
  avoid_double_and_int_checks
  use_colored_box
  use_decorated_box
  use_string_buffers
  sort_constructors_first
  use_named_constants
  curly_braces_in_flow_control_structures
  prefer_relative_imports
  require_trailing_commas
  hash_and_equals
  use_rethrow_when_possible
  throw_in_finally
  await_only_futures
  avoid_null_checks_in_equality_operators
  avoid_field_initializers_in_const_classes
)

# These are analyzer diagnostics (not linter rules) but still worth auto-fixing.
DIAGNOSTIC_FIX_CODES=(
  duplicate_import
  unused_import
  unused_local_variable
  unnecessary_import
  unnecessary_non_null_assertion
  unnecessary_question_mark
  unused_catch_stack
)


if [[ "${CI:-false}" == "true" ]]; then
  # All supported fixes enabled by analysis_options.yaml in a single scan.
  # This is faster than launching the analyzer for every individual lint.
  run_step "${DART[@]}" fix --apply
else
  # Preserve the selective local workflow.
  for code in "${LINT_FIX_CODES[@]}"; do
    run_fix_code "$code"
  done
  for code in "${DIAGNOSTIC_FIX_CODES[@]}"; do
    run_fix_code "$code"
  done
fi

run_step "${DART[@]}" format lib test

# The CI workflow runs 'flutter analyze' separately, after applying fixes.
if [[ "${DART_FIX_SKIP_ANALYZE:-0}" != "1" ]]; then
  run_step "${DART[@]}" analyze
fi

echo "✅ Dart fixes and formatting finished."
