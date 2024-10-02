#!/bin/bash

run_with_delay() {
  echo "Running: $1"
  eval "$1"
  sleep 0.5  
}

run_with_delay "dart fix --apply --code=unused_import"
run_with_delay "dart fix --apply --code=unused_local_variable"
run_with_delay "dart fix --apply --code=unnecessary_import"
run_with_delay "dart fix --apply --code=unnecessary_const"
run_with_delay "dart fix --apply --code=unnecessary_string_interpolations"
run_with_delay "dart fix --apply --code=unnecessary_non_null_assertion"
run_with_delay "dart fix --apply --code=sized_box_for_whitespace"
run_with_delay "dart fix --apply --code=unnecessary_question_mark"
run_with_delay "dart fix --apply --code=prefer_const_constructors"
run_with_delay "dart fix --apply --code=avoid_unnecessary_containers"

echo "All fixes applied."
