#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Determine the directory with files
SCRIPT_DIR="$(realpath "$(dirname "${0}")/../")"

RENDERTRON_IMAGE='quay.io/tike/helsinki-fi-rendertron'
PRERENDER_IMAGE='quay.io/tike/helsinki-fi-prerender'

docker 'build' \
	--tag "${RENDERTRON_IMAGE}:latest" \
	"${SCRIPT_DIR}/rendertron"

docker 'build' \
	--tag "${PRERENDER_IMAGE}:latest" \
	"${SCRIPT_DIR}/prerender"

docker 'push' \
	"${RENDERTRON_IMAGE}:latest"

docker 'push' \
	"${PRERENDER_IMAGE}:latest"
