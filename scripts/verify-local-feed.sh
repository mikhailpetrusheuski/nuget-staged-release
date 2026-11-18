#!/usr/bin/env bash
# Packs the release set into ./artifacts and restores it from that folder
# in a clean consumer project, pinned to the exact version.
set -euo pipefail

VERSION="${1:?usage: verify-local-feed.sh <version>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

rm -rf "$ROOT/artifacts"
dotnet pack "$ROOT/StagedRelease.slnx" -c Release -o "$ROOT/artifacts" -p:Version="$VERSION"

CACHE="$(mktemp -d)"
trap 'rm -rf "$CACHE"' EXIT

RELEASE_VERSION="$VERSION" NUGET_PACKAGES="$CACHE" \
  dotnet run --project "$ROOT/tests/ConsumerSmoke" -p:ReleaseVersion="$VERSION"
