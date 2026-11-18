# NuGet Staged Release

A small .NET sample that stages a two-package release on NuGet.org instead of publishing it, so a maintainer promotes the exact validated set by hand.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![.NET 11 SDK](https://img.shields.io/badge/.NET_SDK-11-512BD4)](https://dotnet.microsoft.com/)
[![Stars](https://img.shields.io/github/stars/mikhailpetrusheuski/nuget-staged-release?style=social)](https://github.com/mikhailpetrusheuski/nuget-staged-release/stargazers)

Read the write-up: [NuGet.org Just Added a Human Release Gate for .NET Packages](https://medium.com/@mikhail.petrusheuski/nuget-org-just-added-a-human-release-gate-for-net-packages-f07f7c7cc9be).

## What is here

| Path | Purpose |
| --- | --- |
| `src/` | `StagedRelease.Sample` and `StagedRelease.Sample.Extensions`, which depends on it |
| `scripts/verify-local-feed.sh` | Packs into `./artifacts` and restores the exact version in a clean consumer from that folder |
| `scripts/stage.sh` | Runs `dotnet package stage push` for every `.nupkg` into one staging group; never promotes |
| `scripts/verify-public-restore.sh` | After promotion, waits until every package version is listed on NuGet.org |
| `.github/workflows/release.yml` | Manual workflow: local feed check, then staging with a staging-only key |
| `docs/promotion-checklist.md` | What the maintainer checks before pressing **Promote group** |

## Run the local check

```bash
./scripts/verify-local-feed.sh 1.2.0
```

It prints `StagedRelease.Sample 1.2.0` and exits with 0. The consumer pins `[1.2.0]` and uses package source mapping, so `StagedRelease.*` can only come from `./artifacts`.

## Why the public check matters

Promoting a staging group is not atomic. `StagedRelease.Sample.Extensions` depends on `StagedRelease.Sample >= 1.2.0`. If the companion is visible and the core package is not yet, restore fails with `NU1101`. The local feed reproduces that when it holds only the companion package. Run the public check before you announce:

```bash
./scripts/verify-public-restore.sh 1.2.0 StagedRelease.Sample StagedRelease.Sample.Extensions
```

## Setup on NuGet.org

1. Create an API key scoped to staging only, limited to your package IDs.
2. Store it as `NUGET_STAGING_API_KEY` in a GitHub environment named `nuget-staging`.
3. Prefer NuGet Trusted Publishing with a staging-only policy once it fits your setup, so there is no long-lived key at all.

`dotnet package stage push` ships in the .NET 11 SDK. Promotion is a NuGet.org website action.

## What was verified

The pack, local feed restore, dependency gap and public restore polling scripts were run locally. The staging push itself was not run against NuGet.org, because that needs a real package ID and key. Symbol package handling for staged uploads is not described in the announcement; check it on your first staged release.

## References

- [Introducing staged publishing on NuGet.org](https://devblogs.microsoft.com/dotnet/nuget-staged-publishing/)
- [Trusted Publishing on nuget.org](https://learn.microsoft.com/en-us/nuget/nuget-org/trusted-publishing)
