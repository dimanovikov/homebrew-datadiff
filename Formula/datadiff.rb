class Datadiff < Formula
  desc "Semantic diff for structured data files (JSON, YAML, CSV, TOML, XML)"
  homepage "https://github.com/cloudroad-io/datadiff"
  version "0.3.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.3.0/datadiff-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "e4829b3da282407dc9a79f5d4b5d97ed6480353cd0dcfd0a1917a67a2092ded1"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/cloudroad-io/datadiff/archive/refs/tags/v0.3.0.tar.gz"
      sha256 "e9a259a7331aa72c38e7eaf3c4f2ffe5e6f0c2e72a5bbca5cc09f1e5433d5726"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.3.0/datadiff-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d38ba1675880205cc33eb4ed7a4817b7596cb678e7acf05b13cd0e07e734007"
    end
    on_arm do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.3.0/datadiff-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fd8ba8ba29ef81b38f5c87409ca67bfbdd5e5e9c37d2681157e7c9a852a45b71"
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
