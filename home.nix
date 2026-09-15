{ pkgs, lib, ... }:
{
  home.username = "mark";
  home.homeDirectory = "/Users/mark";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  home.packages = with pkgs; [ ghostty-bin whatsapp-for-mac ];

  programs.git = {
    enable = true;
    settings.init.defaultBranch = "main";
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
    gitCredentialHelper.enable = true;
  };

  # Copy signed app bundles so Finder and Spotlight can discover them.
  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = false;

  # 1Password requires the system Applications folder for its integrations.
  # Keep it out of home.packages so copyApps does not create a second copy.
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
}
