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
  local error_output

  if ! actual_user="$(docker image inspect "$image_tag" --format '{{.Config.User}}' 2>&1)"; then
    echo "$actual_user"
    fail "Unable to inspect image metadata for runtime user"
  fi

  if [[ -z "$actual_user" ]]; then
    if ! actual_user="$(run_in_image "$image_tag" 'id -un')"; then
      error_output="$(run_in_image "$image_tag" 'id -un' 2>&1 || true)"
      if [[ -n "$error_output" ]]; then
        echo "$error_output"
      fi
      fail "Container failed to start with default user"
    fi
  fi

  if [[ -z "$actual_user" ]]; then
    if [[ -n "$error_output" ]]; then
      echo "$error_output"
    fi
    fail "Unable to determine runtime user"
  fi

  # Normalize command output in case a shell wrapper emits extra lines.
  actual_user="${actual_user//$'\r'/}"
  actual_user="${actual_user##*$'\n'}"

  if [[ "$actual_user" != "$expected_user" ]]; then
    fail "Expected default runtime user $expected_user, got $actual_user"
  fi
}

ensure_results_dir() {
  local results_dir="$1"
  mkdir -p "$results_dir"
}
