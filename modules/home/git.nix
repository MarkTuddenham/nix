{ lib, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [
      "**/.DS_store"
      "**/.directory"
      ".directory"
      "todo.md"
      ".env"
      "venv/"
      "*.bk"
      "**/__pycache__/"
      "**/.mypy_cache/"
      "result"
      ".idea"
      "*~"
      "*.swp"
      "CLADUE.md"
    ];
    settings = {
      user = {
        name = "Mark Tuddenham";
        email = "mark@tudders.com";
      };
      alias = {
        s = "status";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
      };
      init.defaultBranch = lib.mkDefault "main";
      push.default = "simple";
      pull.rebase = true;
      rebase.autoStash = true;
      rerere.enabled = true;
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    gitCredentialHelper.enable = true;
  };
}
