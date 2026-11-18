# NuGet promotion gate

Run this on NuGet.org before you press **Promote group**.

- [ ] Package IDs match the release plan
- [ ] Versions match the approved release
- [ ] Every intended package, analyzer and generator is present
- [ ] No unexpected package is present
- [ ] All NuGet.org validation checks passed
- [ ] The local feed check passed for this exact version
- [ ] Dependency version ranges match the staged release set
- [ ] Repository URL and commit in the package metadata are correct
- [ ] Release notes name the same commit and versions
- [ ] I approve promotion

After promotion:

- [ ] `scripts/verify-public-restore.sh <version> <ids...>` reports every package
- [ ] Only then announce the release
