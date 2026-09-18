{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.whatsapp-for-mac ];

  programs.ghostty.package = pkgs.ghostty-bin;

  # Copy signed app bundles so Finder and Spotlight can discover them.
  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = false;

  # 1Password requires the system Applications folder for its integrations.
  home.activation.install1Password = lib.hm.dag.entryAfter [ "copyApps" ] ''
    sourceApp=${pkgs._1password-gui}/Applications/1Password.app
    sourceVersion=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$sourceApp/Contents/Info.plist")
    installedVersion=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' /Applications/1Password.app/Contents/Info.plist 2>/dev/null || true)

    if [[ "$sourceVersion" != "$installedVersion" ]]; then
      run /usr/bin/sudo /bin/mkdir -p /Applications/1Password.app
      run /usr/bin/sudo ${pkgs.rsync}/bin/rsync \
        --recursive --checksum --perms --links --copy-unsafe-links \
        --specials --delete --chmod=+w \
        "$sourceApp/" /Applications/1Password.app/
    fi
  '';

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
