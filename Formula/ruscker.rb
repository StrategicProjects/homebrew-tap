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
  version "0.2.29"

  on_macos do
    url "https://github.com/StrategicProjects/ruscker/archive/refs/tags/v#{version}.tar.gz"
    sha256 "3ee25f04790bf95ce5bf7620a1bcd5f82f1cbab6af529ceef8ff33421b66656a"
    depends_on "rust" => :build

    def install
      system "cargo", "install", *std_cargo_args(path: "crates/ruscker-cli")
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/StrategicProjects/ruscker/releases/download/v#{version}/ruscker-#{version}-linux-arm64.tar.gz"
      sha256 "7d8d4a17dcec734c4c922c4f78e766e0b79b5a4021f18b2e1e53abdcc5daadfd"
    end
    on_intel do
      url "https://github.com/StrategicProjects/ruscker/releases/download/v#{version}/ruscker-#{version}-linux-amd64.tar.gz"
      sha256 "28b62a57051fca4da39581aea581d045ec3e496e78d8e2319839cb98df297df8"
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
