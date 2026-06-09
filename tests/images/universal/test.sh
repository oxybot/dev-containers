#!/usr/bin/env bash

set -Eeuo pipefail

# shellcheck source=tests/lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)/tests/lib/common.sh"

IMAGE_TAG="$1"
USERNAME="$2"

log "Smoke test (universal): validate node and npm are available"
run_in_image "$IMAGE_TAG" 'node -v && npm -v'

log "Smoke test (universal): validate pnpm is available"
run_in_image "$IMAGE_TAG" 'pnpm -v'

log "Smoke test (universal): validate python3 and dotnet are available"
run_in_image "$IMAGE_TAG" 'python3 --version && dotnet --version'

log "Smoke test (universal): validate Playwright CLI is available"
run_in_image "$IMAGE_TAG" 'npx playwright --version'

log "Smoke test (universal): validate runtime user is $USERNAME"
assert_runtime_user "$IMAGE_TAG" "$USERNAME"

log "Universal image tests passed"
