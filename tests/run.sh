#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=tests/lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=tests/lib/trivy.sh
source "$SCRIPT_DIR/lib/trivy.sh"
# shellcheck source=tests/manifest.sh
source "$SCRIPT_DIR/manifest.sh"

TARGET_IMAGE=""
IMAGE_TAG=""
USERNAME="vscode"
NODE_VERSION="24"
RUN_TRIVY="true"
TRIVY_SEVERITY="CRITICAL"
RESULTS_DIR="test-results"
BUILD_IMAGE="true"

usage() {
  cat <<'EOF'
Usage: ./tests/run.sh <image|all> [options]

Positional:
  <image|all>                 base, node, universal, or all

Options:
  --tag <image-tag>           Override image tag for single-image runs
  --username <name>           Expected runtime user (default: vscode)
  --node-version <version>    Build arg NODE_VERSION (default: 24)
  --skip-trivy                Skip Trivy vulnerability scan
  --trivy-severity <levels>   Trivy severities (default: CRITICAL)
  --results-dir <dir>         Output directory for reports (default: test-results)
  --skip-build                Skip docker build and test an existing local tag
  -h, --help                  Show this help

Examples:
  ./tests/run.sh base
  ./tests/run.sh node --skip-trivy
  ./tests/run.sh universal --tag universal:local --skip-build
  ./tests/run.sh all
EOF
}

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)
      IMAGE_TAG="$2"
      shift 2
      ;;
    --username)
      USERNAME="$2"
      shift 2
      ;;
    --node-version)
      NODE_VERSION="$2"
      shift 2
      ;;
    --skip-trivy)
      RUN_TRIVY="false"
      shift
      ;;
    --trivy-severity)
      TRIVY_SEVERITY="$2"
      shift 2
      ;;
    --results-dir)
      RESULTS_DIR="$2"
      shift 2
      ;;
    --skip-build)
      BUILD_IMAGE="false"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      fail "Unknown option: $1"
      ;;
    *)
      if [[ -z "$TARGET_IMAGE" ]]; then
        TARGET_IMAGE="$1"
        shift
      else
        fail "Unexpected argument: $1"
      fi
      ;;
  esac
done

[[ -n "$TARGET_IMAGE" ]] || fail "Missing required argument: <image|all>"

require_cmd docker
ensure_results_dir "$REPO_ROOT/$RESULTS_DIR"

trivy_report_path() {
  local image_ref="$1"
  local safe_name

  safe_name="${image_ref//\//_}"
  safe_name="${safe_name//:/_}"
  safe_name="${safe_name//@/_}"
  echo "$REPO_ROOT/$RESULTS_DIR/trivy-${safe_name}.txt"
}

run_one_image() {
  local image="$1"
  local dockerfile tag test_script

  image_exists "$image" || fail "Unsupported image: $image"

  dockerfile="$(image_dockerfile "$image")"
  tag="$IMAGE_TAG"
  if [[ -z "$tag" ]]; then
    tag="$(image_default_tag "$image")"
  fi

  test_script="$(image_test_script "$image")"
  test_script="$REPO_ROOT/$test_script"

  [[ -f "$test_script" ]] || fail "Missing test script for image $image"

  if [[ "$BUILD_IMAGE" == "true" ]]; then
    log "Building image $tag from $dockerfile"
    docker build \
      -f "$REPO_ROOT/$dockerfile" \
      -t "$tag" \
      --build-arg "USERNAME=$USERNAME" \
      --build-arg "NODE_VERSION=$NODE_VERSION" \
      "$REPO_ROOT"
  else
    log "Skipping build for image $image; testing existing tag $tag"
  fi

  log "Running image-specific tests for $image"
  "$test_script" "$tag" "$USERNAME"

  if [[ "$RUN_TRIVY" == "true" ]]; then
    local report_file
    require_cmd trivy
    report_file="$(trivy_report_path "$tag")"
    log "Running Trivy scan on $tag with severity $TRIVY_SEVERITY"
    scan_image_with_trivy "$tag" "$TRIVY_SEVERITY" "$report_file"
    log "Trivy report saved to $report_file"
  else
    log "Skipping Trivy scan for $image"
  fi

  log "All checks passed for $image ($tag)"
}

if [[ "$TARGET_IMAGE" == "all" ]]; then
  if [[ -n "$IMAGE_TAG" ]]; then
    fail "--tag can only be used with a single image"
  fi

  for image in base node universal; do
    run_one_image "$image"
  done
else
  run_one_image "$TARGET_IMAGE"
fi
