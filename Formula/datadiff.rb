class Datadiff < Formula
  desc "Semantic diff for structured data files (JSON, YAML, CSV, TOML, XML)"
  homepage "https://github.com/cloudroad-io/datadiff"
  version "0.2.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.2.1/datadiff-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "936b0a27dc6abd52bf98f5d63b9482acb7614d704f91d2f614abe66079be1eb8"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/cloudroad-io/datadiff/archive/refs/tags/v0.2.1.tar.gz"
      sha256 "e4d9d7939c74f00d271a215255fa67a507acf81ad642503cfa9a6b3d5443f59b"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.2.1/datadiff-v0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b5bc35fe2fb56a14bd725e347ed2e379a66f7a17b883f2e495f24424e7c1884e"
    end
    on_arm do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.2.1/datadiff-v0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d56fe5187afefed26e1f6625b209e74b74440b2f3f244c4009f66051c4b35db"
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
