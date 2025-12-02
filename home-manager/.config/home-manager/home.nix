{config, pkgs, ... }:

{
  imports = [
    ./rust.nix
  ] ;
  home.username= "fahd";
  home.homeDirectory = "/home/fahd";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    nodejs_22
    python314
    bun
    gcc
    pkg-config
    openssl
    less

    nixfmt
  ];

  programs.home-manager.enable = true;
}
