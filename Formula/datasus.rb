# Homebrew formula for the `datasus` command-line tool.
#
# This is the canonical copy. It is published by copying it into the tap
# repo `StrategicProjects/homebrew-tap` as `Formula/datasus.rb`, after which
#   brew install strategicprojects/tap/datasus
# works. It builds from source (needs Rust) on macOS and Linux.
#
# When cutting a release, update the tag in `url` and `sha256` (checksum of
# the GitHub auto-generated source tarball for that tag).
class Datasus < Formula
  desc "Convert DATASUS .dbc/.dbf files to Parquet, CSV or DBF"
  homepage "https://github.com/StrategicProjects/datasus-rs"
  url "https://github.com/StrategicProjects/datasus-rs/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "756ad628c760301d827eb70803ed8c7529566fabcfd9b2cc149bc762eed09bd7"
  license "MIT"
  head "https://github.com/StrategicProjects/datasus-rs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/datasus-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datasus --version")

    # Minimal dBase III file: one numeric field (ID, 3 bytes), two records,
    # the first one flagged as deleted.
    header = [0x03, 24, 1, 1].pack("C*") + [2, 65, 4].pack("Vvv") + ("\0" * 20)
    field = "ID".ljust(11, "\0") + "N" + ("\0" * 4) + [3, 0].pack("CC") + ("\0" * 14)
    (testpath/"t.dbf").binwrite(header + field + "\r" + "*  1" + "   2" + "\x1A")

    system bin/"datasus", "convert", "t.dbf", "-o", "t.csv", "--quiet"
    assert_equal "id\n2\n", (testpath/"t.csv").read
  end
end
