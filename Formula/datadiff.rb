class Datadiff < Formula
  desc "Semantic diff for structured data files (JSON, YAML, CSV, TOML, XML)"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.3.2"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.2/datadiff-v0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "6a68b9a2720b147049a96412483e925dd3eaf1251588bd5ce4a967dd183ddb0e"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.3.2.tar.gz"
      sha256 "0f015efcd8fd5d6fd4b0302217d32efdf4ea679ebc87559bf2d233716af4e693"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.2/datadiff-v0.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b7147b020a383e7e6cb296eee9731fac3fbc1b56ad7d9b96701ba34647385fca"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.2/datadiff-v0.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd3ac27406c8a61c3a64d99f6d75d37955f67f8a6e2adea2ff34b4d279a8e696"
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
