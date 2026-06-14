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
  version "0.2.25"

  on_macos do
    url "https://github.com/StrategicProjects/ruscker/archive/refs/tags/v#{version}.tar.gz"
    sha256 "6aa39a67f9f6e8674cd017a48488f12606e2fa221c08b113e4fc2e4ee8d3e6aa"
    depends_on "rust" => :build

    def install
      system "cargo", "install", *std_cargo_args(path: "crates/ruscker-cli")
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/StrategicProjects/ruscker/releases/download/v#{version}/ruscker-#{version}-linux-arm64.tar.gz"
      sha256 "9d7afb3d9a3039c6a1b1c2a6bd00141ffd33d545caa781966c8b45ba06c32833"
    end
    on_intel do
      url "https://github.com/StrategicProjects/ruscker/releases/download/v#{version}/ruscker-#{version}-linux-amd64.tar.gz"
      sha256 "a25453d2de38746f3c895e1d16c4f3cff35534717481d4b2208bff79fdff87f1"
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
