# Homebrew formula for Ruscker.
#
# This is the canonical copy, version-controlled here. It is published
# by copying it into the tap repo `StrategicProjects/homebrew-tap` as
# `Formula/ruscker.rb` (see packaging/homebrew/README.md), after which
#   brew install strategicprojects/tap/ruscker
# works.
#
# On macOS there is no prebuilt binary yet, so the formula builds from
# source (needs Rust). On Linux it pulls the static musl tarball that
# `release.yml` attaches to the GitHub Release.
#
# When cutting a release, update `version` and the three `sha256`
# values (the Linux tarball checksums are in the release's
# `*.sha256` assets; the macOS source checksum is the GitHub
# auto-generated source tarball's sha256).
class Ruscker < Formula
  desc "Lightweight Rust proxy for containerized apps (Shiny/Streamlit/Dash) and APIs"
  homepage "https://strategicprojects.github.io/ruscker/"
  license "Apache-2.0"
  version "0.1.88"

  on_macos do
    url "https://github.com/StrategicProjects/ruscker/archive/refs/tags/v#{version}.tar.gz"
    sha256 "c89045103fa699c4bf56a0a9e5df3d9853339d990832663276e44dcf4f6005dd"
    depends_on "rust" => :build

    def install
      system "cargo", "install", *std_cargo_args(path: "crates/ruscker-cli")
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/StrategicProjects/ruscker/releases/download/v#{version}/ruscker-#{version}-linux-arm64.tar.gz"
      sha256 "6621be22810fe7ee5e2a4456905146991cee9a80a87e1b726fcace7511425573"
    end
    on_intel do
      url "https://github.com/StrategicProjects/ruscker/releases/download/v#{version}/ruscker-#{version}-linux-amd64.tar.gz"
      sha256 "7181a6236bd56a4eaceff47ea9cf3fff71729e1d4631ae9d1a9b40651c3179c8"
    end

    def install
      # The tarball contains a single top-level dir; Homebrew has
      # already descended into it, so the binary is in the cwd.
      bin.install "ruscker"
    end
  end

  test do
    assert_match "ruscker", shell_output("#{bin}/ruscker --help")
  end
end
