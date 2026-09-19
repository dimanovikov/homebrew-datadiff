class Datadiff < Formula
  desc "Semantic diff for JSON, YAML, CSV, TOML and XML that plugs into git diff"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.4.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.1/datadiff-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "8397649412811a80c6892586d58ecae77c67ff676da79e08e5ca4b58423956c9"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.4.1.tar.gz"
      sha256 "0ed60265d5e89fe0c98f9ee345de4813ea3e04fb00edde96ca6593a87ced42fe"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.1/datadiff-v0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "412bbde445e86f0f211639d6006bddc6a4e3048fb8626b5e1248d6d6759ffce4"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.1/datadiff-v0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3913718108d521748e66cf89cb1fe8f62c03f5950f086e29b63642c577e9accb"
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
