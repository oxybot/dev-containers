#!/usr/bin/env bash

# shellcheck shell=bash

log() {
  printf "\n[%s] %s\n" "$(date +"%H:%M:%S")" "$*"
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || fail "Required command not found: $cmd"
}

run_in_image() {
  local image_tag="$1"
  local command="$2"
  docker run --rm "$image_tag" bash -lc "$command"
}

assert_runtime_user() {
  local image_tag="$1"
  local expected_user="$2"
  local actual_user

  if ! actual_user="$(run_in_image "$image_tag" 'whoami' 2>&1)"; then
    echo "$actual_user"
    fail "Container failed to start with default user"
  fi

  if [[ "$actual_user" != "$expected_user" ]]; then
    fail "Expected default runtime user $expected_user, got $actual_user"
  fi
}

ensure_results_dir() {
  local results_dir="$1"
  mkdir -p "$results_dir"
}
