class Datadiff < Formula
  desc "Semantic diff for structured data files (JSON, YAML, CSV, TOML, XML)"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.3.2"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.2/datadiff-v0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "69d985ecc20ec78bf3502b89e5ee4b80d39ff0841277b386daa09d0d890cd3fd"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.3.2.tar.gz"
      sha256 "90bbc9135212b594769998ccde2471878196e97e04e87c01a313b36729242c70"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.2/datadiff-v0.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3560ae8fc868a8a3d2abfa5a6552d31f5dcbca7b114885d91f48ef556c964c13"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.3.2/datadiff-v0.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d2448bf6a28678c65c51e20836ac980f57981c351c247bf275bd149a3ee0d3e3"
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
