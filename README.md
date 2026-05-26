# Ruscker Homebrew tap

[Ruscker](https://strategicprojects.github.io/ruscker/) — a lightweight
Rust alternative to ShinyProxy / Shiny Server Free.

```sh
brew install strategicprojects/tap/ruscker
# or
brew tap strategicprojects/tap && brew install ruscker
```

- **Linux** (Linuxbrew): installs the prebuilt static-musl binary from
  the GitHub release.
- **macOS**: builds from source (requires Rust; no prebuilt macOS
  binary yet).

The formula's canonical source lives in the main repo at
[`packaging/homebrew/ruscker.rb`](https://github.com/StrategicProjects/ruscker/blob/main/packaging/homebrew/ruscker.rb).
On each release, bump `version` + the three `sha256` values (see that
repo's `packaging/homebrew/README.md`).

> The current formula carries `sha256` placeholders until the first
> tagged `v0.1.0` release; it won't install until those are filled in.
