{pkgs, ...}:

let
  rust-overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");

  rustPkgs = import pkgs.path {
    overlays = [ rust-overlay ];
  };

  rustToolchain = rustPkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" "rustfmt" "clippy" ];
  };
in
{
  home.packages = [
    rustToolchain
    rustPkgs.rust-analyzer
  ];

  home.sessionVariables.RUST_SRC_PATH = "${rustPkgs.rustPlatform.rustLibSrc}";
}
