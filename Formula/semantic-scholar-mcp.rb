class SemanticScholarMcp < Formula
  desc "Unofficial Rust SDK and MCP server for the Semantic Scholar API"
  homepage "https://github.com/ynishi/semantic-scholar-rs"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/semantic-scholar-rs/releases/download/v0.1.1/semantic-scholar-rs-aarch64-apple-darwin.tar.xz"
      sha256 "aced1e708407bfc41fb18482ae415894ba151edce19c098ce4ddba10fcfedbfd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/semantic-scholar-rs/releases/download/v0.1.1/semantic-scholar-rs-x86_64-apple-darwin.tar.xz"
      sha256 "761e01d267c5f61b987a563811c528a73eca9b1cc74331551b0490dffee00f9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/semantic-scholar-rs/releases/download/v0.1.1/semantic-scholar-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7fef44661a97cf7c38a1f22d3b12e2e75293e769e7f5592abf4a224da2e8034e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/semantic-scholar-rs/releases/download/v0.1.1/semantic-scholar-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d85f46fb15257762408ccb926cc9c8acdfa7d97aa62bea45dc1c003b68a47ff4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "semantic-scholar-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "semantic-scholar-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "semantic-scholar-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "semantic-scholar-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
