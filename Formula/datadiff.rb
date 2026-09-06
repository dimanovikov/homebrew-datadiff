class Datadiff < Formula
  desc "Semantic diff for structured data files (JSON, YAML, CSV, TOML, XML)"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.3.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.1/datadiff-v0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "1e2d380cde829786ca2d5cdeba917e61d63bbf2a176baad36c0042e4cdcf19f0"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.3.1.tar.gz"
      sha256 "0e5e05f375b313043fcea3a1dff3b2dbed414a46c81c9026ce81619897f4bca9"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.1/datadiff-v0.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ee6de152a7b807f8651f2808e91ccfb6d70d328513d82a34036ed55ab1d0e276"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.1/datadiff-v0.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2bd808cfd1b6806afebc0e306e2ebdd810899e964c4214a9084dca90e696759"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "datadiff"
    end
  end

  test do
    (testpath/"old.json").write '{"a": 1, "b": 2}'
    (testpath/"new.json").write '{"b": 2, "a": 3}'
    output = shell_output("#{bin}/datadiff old.json new.json", 1)
    assert_match "~ a: 1 → 3", output
  end
end
