{ pkgs, ... }:
{
  home.file = {
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
    ".config/zed/settings.json".source = ../../dotfiles/zed/settings.json;
    ".config/zed/themes/belafonte_day.json".source = ../../dotfiles/zed/themes/belafonte_day.json;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      stylua
      ripgrep
      rust-analyzer
      tree-sitter
      python312Packages.python-lsp-server
    ];
    extraPython3Packages = ps: with ps; [
      pynvim
      jupyter-client
    ];
  };
}
