{
  description = "fahd NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "path:./home-manager/zen";  
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zen-browser }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ({ config, pkgs, ... }: {
          # Ensure the flake is properly activated
          nix.registry.nixpkgs.flake = nixpkgs;
          
          # Add Zen browser to system packages
          environment.systemPackages = [
            zen-browser.packages.${system}.default
          ];
          
          # Add system-wide flake support
          nix.settings = {
            experimental-features = [ "nix-command" "flakes" ];
            auto-optimise-store = true;
          };
        })
      ];
    };
  };
}