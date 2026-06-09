#!/usr/bin/env bash

# shellcheck shell=bash

image_exists() {
  case "$1" in
    base|node|universal) return 0 ;;
    *) return 1 ;;
  esac
}

image_dockerfile() {
  case "$1" in
    base) echo "base.Dockerfile" ;;
    node) echo "node.Dockerfile" ;;
    universal) echo "universal.Dockerfile" ;;
  esac
}

image_default_tag() {
  echo "$1:test"
}

image_test_script() {
  echo "tests/images/$1/test.sh"
}
