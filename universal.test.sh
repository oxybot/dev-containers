#!/usr/bin/env bash

set -Eeuo pipefail

IMAGE_TAG="universal:test"
DOCKERFILE="universal.Dockerfile"
USERNAME="vscode"
NODE_VERSION="24"
RUN_TRIVY="true"
TRIVY_SEVERITY="CRITICAL"
TRIVY_REPORT="test-results/trivy-universal-report.txt"

log() {
  printf "\n[%s] %s\n" "$(date +"%H:%M:%S")" "$*"
}

usage() {
  cat <<'EOF'
Usage: ./universal.test.sh [options]

Options:
  --tag <image-tag>            Image tag to build/test (default: universal:test)
  --dockerfile <path>          Dockerfile path (default: universal.Dockerfile)
  --username <name>            Expected runtime user (default: dev)
  --node-version <version>     Build arg NODE_VERSION (default: 24)
  --skip-trivy                 Skip Trivy vulnerability scan
  --trivy-severity <levels>    Trivy severities (default: CRITICAL)
  -h, --help                   Show this help

Examples:
  ./universal.test.sh
  ./universal.test.sh --node-version 22 --username vscode
  ./universal.test.sh --skip-trivy
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)
      IMAGE_TAG="$2"
      shift 2
      ;;
    --dockerfile)
      DOCKERFILE="$2"
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
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required but was not found in PATH"
  exit 1
fi

log "Building image $IMAGE_TAG from $DOCKERFILE"
docker build \
  -f "$DOCKERFILE" \
  -t "$IMAGE_TAG" \
  --build-arg "USERNAME=$USERNAME" \
  --build-arg "NODE_VERSION=$NODE_VERSION" \
  .

log "Smoke test: validate node, npm, and pnpm are available"
docker run --rm "$IMAGE_TAG" bash -lc 'node -v && npm -v && pnpm -v'

log "Smoke test: validate Playwright CLI is available"
docker run --rm "$IMAGE_TAG" bash -lc 'npx playwright --version'

log "Smoke test: validate runtime user is $USERNAME"
if ! actual_user="$(docker run --rm "$IMAGE_TAG" bash -lc 'whoami' 2>&1)"; then
  echo "$actual_user"
  echo "Container failed to start with default user."
  echo "Check USERNAME build arg and ensure that user exists in the image."
  exit 1
fi

if [[ "$actual_user" != "$USERNAME" ]]; then
  echo "Expected default runtime user $USERNAME, got $actual_user"
  exit 1
fi

if [[ "$RUN_TRIVY" == "true" ]]; then
  if command -v trivy >/dev/null 2>&1; then
    log "Running Trivy scan with severity $TRIVY_SEVERITY"
    trivy image \
      --severity "$TRIVY_SEVERITY" \
      --ignore-unfixed \
      --scanners vuln \
      --format table \
      --output "$TRIVY_REPORT" \
      --exit-code 1 \
      "$IMAGE_TAG"
    log "Trivy report saved to $TRIVY_REPORT"
  else
    log "Trivy not found. Install Trivy or re-run with --skip-trivy"
  fi
else
  log "Skipping Trivy scan"
fi

log "All tests passed for $IMAGE_TAG"
