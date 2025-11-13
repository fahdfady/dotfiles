{ config, pkgs, ... }:

let
  rust-overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  myPkgs = import <nixpkgs> {
    overlays = [ rust-overlay ];
  };
in
{
  home.username = "fahd";
  home.homeDirectory = "/home/fahd";
  home.stateVersion = "25.11";

  home.packages = with myPkgs; [
    nodejs_22
    python314
    bun
    gcc
    pkg-config
    openssl

    # Rust toolchain with rust-src
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rustfmt" "clippy" ];
    })

    rust-analyzer
  ];

  programs.home-manager.enable = true;

  # Tell rust-analyzer where stdlib sources are
  home.sessionVariables = {
    RUST_SRC_PATH = "${myPkgs.rustPlatform.rustLibSrc}";
  };
}

