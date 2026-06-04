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
  version "0.1.63"

  on_macos do
    url "https://github.com/StrategicProjects/ruscker/archive/refs/tags/v#{version}.tar.gz"
    sha256 "af2deef13b41e1b58cfc87b4d28533d9744ecfb409547266bdbde63dd63dd8c2"
    depends_on "rust" => :build

    def install
      system "cargo", "install", *std_cargo_args(path: "crates/ruscker-cli")
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/StrategicProjects/ruscker/releases/download/v#{version}/ruscker-#{version}-linux-arm64.tar.gz"
      sha256 "c6df5c00508b93e314f7e7258c3ab863641041009c44b0ae93c6992fbd73ab34"
    end
    on_intel do
      url "https://github.com/StrategicProjects/ruscker/releases/download/v#{version}/ruscker-#{version}-linux-amd64.tar.gz"
      sha256 "853b0ab892eba667a18b70ca8b0ae223fc4bedbe9c7b74ffa4fc74760273669a"
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
