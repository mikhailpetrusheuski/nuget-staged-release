#!/usr/bin/env bash
# Stages every normal package in ./artifacts into one NuGet.org staging group.
# Requires the .NET 11 SDK. It never promotes: promotion is a website action.
set -euo pipefail

GROUP="${1:?usage: stage.sh <group-name>}"
: "${NUGET_API_KEY:?NUGET_API_KEY must hold a staging-only key}"

count=0
while IFS= read -r -d '' package; do
  dotnet package stage push "$package" \
    --source https://api.nuget.org/v3/index.json \
    --api-key "$NUGET_API_KEY" \
    --group "$GROUP"
  count=$((count + 1))
done < <(find ./artifacts -maxdepth 1 -type f -name '*.nupkg' ! -name '*.symbols.nupkg' -print0)

if [ "$count" -eq 0 ]; then
  echo "No packages found in ./artifacts" >&2
  exit 1
fi

echo "Staged $count package(s) in group '$GROUP'. Review and promote on NuGet.org."
