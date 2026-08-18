class Datadiff < Formula
  desc "Semantic diff for structured data files (JSON, YAML, CSV, TOML, XML)"
  homepage "https://github.com/cloudroad-io/datadiff"
  version "0.2.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.2.0/datadiff-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "56ad9e5fd09af52469c40d82970080260b9853bb99bcc814830ef298923b17e5"
    end
    on_intel do
      # No prebuilt Intel Mac binaries; build from source instead.
      url "https://github.com/cloudroad-io/datadiff/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "f1b7c34850fcba39d2d51b3cd677830ec21619b1e70ad6235558105a89acde1c"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.2.0/datadiff-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c628922a5d9644aaf5fc440c87f275c385c82e5569a595bb2a65738e8810a5b8"
    end
    on_arm do
      url "https://github.com/cloudroad-io/datadiff/releases/download/v0.2.0/datadiff-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d1aac0b377810b8a13128335eb21149545d3c275d850cfad6b1698d31937e101"
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
