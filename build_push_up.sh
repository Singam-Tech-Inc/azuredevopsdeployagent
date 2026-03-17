#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./build_push_up.sh                # build arm64+amd64, then up with host arch image
#   ./build_push_up.sh --push         # build, push both arch tags, then up
#   ./build_push_up.sh --version 1.1
#   ./build_push_up.sh --repo ghcr.io/acme/azdevopsdeploymentagent --push
#
# Optional environment variables:
#   VERSION (default: 1.0)
#   IMAGE_REPO (default: azdevopsdeploymentagent)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

VERSION="${VERSION:-1.0}"
IMAGE_REPO="${IMAGE_REPO:-azdevopsdeploymentagent}"
PUSH_IMAGES=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --push)
      PUSH_IMAGES=true
      shift
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    --repo)
      IMAGE_REPO="$2"
      shift 2
      ;;
    -h|--help)
      sed -n '1,18p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

detect_host_arch() {
  case "$(uname -m)" in
    arm64|aarch64) echo "arm64" ;;
    x86_64|amd64) echo "amd64" ;;
    *)
      echo "Unsupported host architecture: $(uname -m)" >&2
      exit 1
      ;;
  esac
}

build_arch() {
  local arch="$1"
  echo "==> Building ${IMAGE_REPO}:${VERSION}-${arch}"
  TARGETARCH="$arch" VERSION="$VERSION" IMAGE_REPO="$IMAGE_REPO" docker compose build
}

push_arch() {
  local arch="$1"
  local tag="${IMAGE_REPO}:${VERSION}-${arch}"
  echo "==> Pushing ${tag}"
  docker push "$tag"
}

build_arch arm64
build_arch amd64

if [[ "$PUSH_IMAGES" == true ]]; then
  push_arch arm64
  push_arch amd64
fi

HOST_ARCH="$(detect_host_arch)"
HOST_TAG="${IMAGE_REPO}:${VERSION}-${HOST_ARCH}"

echo "==> Host architecture detected: ${HOST_ARCH}"

if ! docker image inspect "$HOST_TAG" >/dev/null 2>&1; then
  echo "==> ${HOST_TAG} not found locally. Trying to pull..."
  if ! docker pull "$HOST_TAG"; then
    echo "==> Pull failed. Building host architecture image locally..."
    build_arch "$HOST_ARCH"
  fi
fi

echo "==> Starting compose with ${HOST_TAG}"
TARGETARCH="$HOST_ARCH" VERSION="$VERSION" IMAGE_REPO="$IMAGE_REPO" docker compose up -d

echo "==> Done"
