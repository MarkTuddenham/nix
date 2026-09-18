{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLI tools
    watch
    hyperfine
    ripgrep
    tokei
    fd
    dust
    delta
    taplo
    samply
    nmap
    ffmpeg
    tree
    par
    eza
    gnupg
    yq
    typst
    _1password-cli
    bat
    jq

    # Development
    (nodejs_24.overrideAttrs (old: { doCheck = false; }))
    uv
    rustup
    pkg-config
    nixfmt
    sqlite
    sqlite.out

    # Language servers and formatters
    ruff
    nixd
    gopls
    clang-tools
    protols
  ];
}
