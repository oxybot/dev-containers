#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_RUNNER="$SCRIPT_DIR/tests/run.sh"

IMAGE_INPUT=""
IMAGE_TAG=""
USERNAME="vscode"
NODE_VERSION="24"
RUN_TRIVY="true"
TRIVY_SEVERITY="CRITICAL"
TAG_EXPLICIT="false"

usage() {
  cat <<'EOF'
Usage: ./test.sh [options]

Required:
  <image>                      Image input: <name> or <name>.Dockerfile

Options:
  --tag <image-tag>            Image tag to build/test (default: <image>:test)
  --username <name>            Expected runtime user (default: vscode)
  --node-version <version>     Build arg NODE_VERSION (default: 24)
  --skip-trivy                 Skip Trivy vulnerability scan
  --trivy-severity <levels>    Trivy severities (default: CRITICAL)
  -h, --help                   Show this help

Examples:
  ./test.sh universal
  ./test.sh universal.Dockerfile
  ./test.sh node --node-version 22 --username vscode
  ./test.sh base --skip-trivy
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)
      IMAGE_TAG="$2"
      TAG_EXPLICIT="true"
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
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      if [[ -z "$IMAGE_INPUT" ]]; then
        IMAGE_INPUT="$1"
        shift
      else
        echo "Unexpected argument: $1"
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$IMAGE_INPUT" ]]; then
  echo "Missing required argument: <image>"
  usage
  exit 1
fi

image_name="$(basename "$IMAGE_INPUT")"
image_name="${image_name%.Dockerfile}"

if [[ "$TAG_EXPLICIT" == "false" ]]; then
  IMAGE_TAG="${image_name}:test"
fi

if [[ ! -x "$TEST_RUNNER" ]]; then
  echo "Missing tests runner at $TEST_RUNNER"
  exit 1
fi

args=(
  "$image_name"
  --tag "$IMAGE_TAG"
  --username "$USERNAME"
  --node-version "$NODE_VERSION"
  --trivy-severity "$TRIVY_SEVERITY"
)

if [[ "$RUN_TRIVY" == "false" ]]; then
  args+=(--skip-trivy)
fi

exec "$TEST_RUNNER" "${args[@]}"
