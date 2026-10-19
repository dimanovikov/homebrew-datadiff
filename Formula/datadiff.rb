class Datadiff < Formula
  desc "Semantic diff for JSON, YAML, CSV, TOML and XML that plugs into git diff"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.6.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.6.0/datadiff-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "4e12066e92609c4ce32479d798f19772bca8fdc40e4c547506834f95a4422e5f"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.6.0.tar.gz"
      sha256 "353bfcd6867d487a33be0796b4b4c1b069b504d18028094536e0cc0937ec31ce"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.6.0/datadiff-v0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2949db89a8449b9ec1808e2cec3e0e5f273d7a2c19730259516abc0cd3d8aab7"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.6.0/datadiff-v0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "270a053074fd1214e15289cda14acbfee7f22e1eb7166e3d9baf5fcf559d6a7c"
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
