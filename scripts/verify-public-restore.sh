#!/usr/bin/env bash
# After promotion, waits until every package version is listed in the
# NuGet.org flat container. Group promotion is not atomic, so check each one.
set -euo pipefail

VERSION="${1:?usage: verify-public-restore.sh <version> <package-id>...}"
shift
[ "$#" -gt 0 ] || { echo "Pass at least one package ID" >&2; exit 1; }

ATTEMPTS="${ATTEMPTS:-60}"
DELAY="${DELAY:-30}"
version_lower="$(echo "$VERSION" | tr '[:upper:]' '[:lower:]')"

for id in "$@"; do
  id_lower="$(echo "$id" | tr '[:upper:]' '[:lower:]')"
  url="https://api.nuget.org/v3-flatcontainer/$id_lower/index.json"
  for ((i = 1; i <= ATTEMPTS; i++)); do
    if curl -fsS "$url" 2>/dev/null | grep -q "\"$version_lower\""; then
      echo "available: $id $VERSION"
      continue 2
    fi
    echo "waiting: $id $VERSION ($i/$ATTEMPTS)"
    sleep "$DELAY"
  done
  echo "not available: $id $VERSION" >&2
  exit 1
done

echo "All packages are restorable from NuGet.org."
