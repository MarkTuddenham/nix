{ ... }:
{
  imports = [
    ./packages.nix
    ./files.nix
    ./git.nix
    ./shell.nix
    ./terminal.nix
    ./editors.nix
  ];

  programs.home-manager.enable = true;
}
