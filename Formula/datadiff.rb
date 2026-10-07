class Datadiff < Formula
  desc "Semantic diff for JSON, YAML, CSV, TOML and XML that plugs into git diff"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.5.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.5.0/datadiff-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "ee83a1319c721ed21c8378fbf19f4437fbb593a5584c4995a86cfbb708c7ae2c"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.5.0.tar.gz"
      sha256 "8d58fbb061143673f783abaf52a949b2ed1bbf3d65be687cad8e1d604f360a20"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.5.0/datadiff-v0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0791cf86a83c36a18f9c699eb806dae20130b06a7a38ac39cac9237b8a99f8d5"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.5.0/datadiff-v0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f0dcabdd5113dcfaceeebc5585bdea021c85cc38efcf0e982566f512e0af75af"
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
