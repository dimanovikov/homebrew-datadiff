class Datadiff < Formula
  desc "Semantic diff for structured data files (JSON, YAML, CSV, TOML, XML)"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.0/datadiff-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "ffc9c1d9aedf998ce9083af86966e2c6670a1f6dd047e97fab6ecdec3621c550"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "4e30ae8b6270c353ac99ba62004ce88ad7da46b392b7d4c3f8841072f624c1f6"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.0/datadiff-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e44abca30f9a88c6d3a7feaf2288f8cf3ec0603a12c01d6403177130eb23026a"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.0/datadiff-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "35df96aacc6a986c5ef8cf6180d8c22c5b8abf245f2c59812b855b75cc8cc183"
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
