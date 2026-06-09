#!/usr/bin/env bash

set -Eeuo pipefail

# shellcheck source=tests/lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)/tests/lib/common.sh"

IMAGE_TAG="$1"
USERNAME="$2"

log "Smoke test (base): validate node and npm are available"
run_in_image "$IMAGE_TAG" 'node -v && npm -v'

log "Smoke test (base): validate Playwright CLI is available"
run_in_image "$IMAGE_TAG" 'npx playwright --version'

log "Smoke test (base): validate runtime user is $USERNAME"
assert_runtime_user "$IMAGE_TAG" "$USERNAME"

log "Base image tests passed"
