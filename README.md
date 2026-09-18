# Nix configuration

Home Manager configuration shared across Mark's machines.

## Layout

- `modules/home/common.nix`: shared entry point
- `modules/home/packages.nix`: shared packages and development tools
- `modules/home/git.nix`: Git identity, behavior, ignores, and GitHub CLI
- `modules/home/shell.nix`: Zsh, aliases, environment, Atuin, FZF, Yazi, and Zoxide
- `modules/home/terminal.nix`: Ghostty, tmux, and Starship settings
- `modules/home/editors.nix`: Neovim and Zed configuration links
- `modules/home/files.nix`: remaining native configuration and scripts
- `modules/home/darwin.nix`: macOS applications and behavior
- `dotfiles/`: native configuration best kept in its application format
- `scripts/`: executable user scripts installed into `~/.local/bin`
- `profiles/`: machine-specific overrides

Most settings live directly in Home Manager modules. Native Neovim Lua,
Claude content, and Zed JSON remain external because their application formats
are clearer and more capable than a Nix translation; Home Manager still owns
and installs those files.

## Apply the MacBook profile

```sh
home-manager switch --flake ~/dev/nix#macbook
```

The work laptop and NixOS profiles stay inactive until their usernames,
architectures, and integration style are known. Add them through the `mkHome`
helper in `flake.nix`, or import the NixOS profile from a system configuration.
