{
  description = "Mark's Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      mkHome =
        {
          system,
          username,
          homeDirectory,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            ./modules/home/common.nix
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "26.05";
              };
            }
          ] ++ modules;
        };
    in
    {
      homeManagerModules.personal = ./modules/home/common.nix;

      homeConfigurations.macbook = mkHome {
        system = "aarch64-darwin";
        username = "mark";
        homeDirectory = "/Users/mark";
        modules = [
          ./modules/home/darwin.nix
          ./profiles/macbook/home.nix
        ];
      };

      # Add work-laptop and nixos here once their usernames and architectures
      # are known. Their profile modules are ready under ./profiles.
    };
}
