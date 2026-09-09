class Datadiff < Formula
  desc "Semantic diff for structured data files (JSON, YAML, CSV, TOML, XML)"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.0/datadiff-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "27863e6732e57a08b17e38020a0edf8033be158ff424170850a70c68b1c3df87"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "01c8154b7891ba702cb09d8b2f96191758af554e9254514558f41966cd06ffcb"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.0/datadiff-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ff3e6edead5a4c14f4e2531c4a8496d90efc1ad96ecf2319ebdbcf8461b87a75"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.4.0/datadiff-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1992c2bd0140fcbf7a5ab721e928308ee15b0c88efddf15338b1164e155e5b1d"
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
