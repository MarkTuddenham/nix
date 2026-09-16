{
  description = "Mark's personal Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    lib = nixpkgs.lib;
    mkHome = system: extraModules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        modules = [ ./home.nix ] ++ extraModules;
      };
  in
  {
    # Import from nix-template or any other flake:
    #   inputs.personal.homeManagerModules.personal
    homeManagerModules.personal = ./home.nix;

    homeConfigurations = {

      # Personal MacBook — GUI apps, 1Password, Darwin-specific setup
      macbook = mkHome "aarch64-darwin" [({ pkgs, lib, ... }: {
        home.username      = "mark";
        home.homeDirectory = "/Users/mark";
        home.stateVersion  = "26.05";
        programs.home-manager.enable = true;

        home.packages = with pkgs; [ ghostty-bin whatsapp-for-mac ];

        targets.darwin.copyApps.enable = true;
        targets.darwin.linkApps.enable = false;

        # 1Password needs system Applications for its SSH agent integration
        home.activation.install1Password = lib.hm.dag.entryAfter [ "copyApps" ] ''
          run /usr/bin/sudo /bin/mkdir -p /Applications/1Password.app
          run /usr/bin/sudo ${pkgs.rsync}/bin/rsync \
            --recursive --checksum --perms --links --copy-unsafe-links \
            --specials --delete --chmod=+w \
            ${pkgs._1password-gui}/Applications/1Password.app/ \
            /Applications/1Password.app/
        '';

        nix.package = pkgs.nix;
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
      })];

      # Add more profiles here, e.g.:
      # linux-x86 = mkHome "x86_64-linux" [({ ... }: { home.username = "mark"; ... })];

    };
  };
}
