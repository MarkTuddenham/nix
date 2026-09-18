{ ... }:
{
  home.file = {
    ".local/bin" = {
      source = ../../scripts;
      recursive = true;
    };
    ".claude" = {
      source = ../../dotfiles/claude;
      recursive = true;
    };
  };
}
