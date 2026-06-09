#!/usr/bin/env bash

# shellcheck shell=bash

scan_image_with_trivy() {
  local image_ref="$1"
  local severity="$2"
  local report_file="$3"

  trivy image \
    --severity "$severity" \
    --ignore-unfixed \
    --scanners vuln \
    --format table \
    --output "$report_file" \
    --exit-code 1 \
    "$image_ref"
}
