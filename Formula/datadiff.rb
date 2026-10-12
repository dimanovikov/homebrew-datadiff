class Datadiff < Formula
  desc "Semantic diff for JSON, YAML, CSV, TOML and XML that plugs into git diff"
  homepage "https://github.com/dimanovikov/datadiff"
  version "0.5.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.5.1/datadiff-v0.5.1-aarch64-apple-darwin.tar.gz"
      sha256 "a933bd553b52b91f82dc736bf38e30f57dfa8d66cced9f7e3fbf3440e15e3e87"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/dimanovikov/datadiff/archive/refs/tags/v0.5.1.tar.gz"
      sha256 "67282df38de9c0d2e28209f5a30d2ba509ccb0385d8292f6d8030b4b07462f8d"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.5.1/datadiff-v0.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "afce32486076e316ba94b819ebad637c972ef7fc5aad59298670a29bbc5884fa"
    end
    on_arm do
      url "https://github.com/dimanovikov/datadiff/releases/download/v0.5.1/datadiff-v0.5.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "79c8e6041f038c8d5df6f8ab08d03459eadf24481b360288084c18a867c9e892"
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
