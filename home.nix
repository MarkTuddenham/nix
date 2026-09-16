{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # CLI tools
    watch hyperfine ripgrep tokei fd dust delta taplo samply nmap ffmpeg
    tree par eza yazi gnupg yq typst _1password-cli

    # Dev
    (nodejs_24.overrideAttrs (old: { doCheck = false; }))
    uv rustup pkg-config nixfmt-rfc-style
    sqlite sqlite.out

    # LSPs / formatters
    ruff nixd gopls clang-tools protols
  ];

  home.file = {
    ".local/bin" = { source = ./local/bin; recursive = true; };
    ".config/nvim" = { source = ./nvim; recursive = true; };
    ".config/ghostty/config".source = ./ghostty/config;
    ".claude/" = { source = ./claude; recursive = true; };
    ".cargo/config.toml".source = ./cargo-config.toml;
    ".config/zed/settings.json".source = ./zed/settings.json;
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      lua-language-server stylua ripgrep rust-analyzer tree-sitter
      python312Packages.python-lsp-server
    ];
    extraPython3Packages = ps: with ps; [ pynvim jupyter-client ];
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [ sensible resurrect continuum ];
  };

  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship/starship.toml);
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = false;
      update_check = false;
      filter_mode = "directory";
      search_mode = "daemon-fuzzy";
      search = { recency_score_multiplier = 10; frecency_score_multiplier = 2; };
      daemon = { enabled = true; autostart = true; };
      tmux.enabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    initContent = builtins.readFile ./zshrc;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = lib.splitString "\n" (builtins.readFile ./git/gitignores);
    settings = {
      alias = {
        s  = "status";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
      };
      init.defaultBranch = lib.mkDefault "main";
      push.default     = "simple";
      pull.rebase      = true;
      rebase.autoStash = true;
      rerere.enabled   = true;
      core = { editor = "nvim"; autocrlf = "input"; };
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
    gitCredentialHelper.enable = true;
  };

  home.shellAliases = {
    ls  = "eza"; ll  = "eza -alh"; la  = "eza -a"; l   = "eza";
    lld = "eza -alh --group-directories-first"; ld = "eza --group-directories-first";
    so = "source"; python = "python3"; py = "python"; py_pdb = "python -m pdb -c continue";
    pip = "pip3"; sshx = "ssh -X"; sshy = "ssh -Y";
    f = "find . -name "; grep = "grep --color=auto";
    fgrep = "fgrep --color=auto"; egrep = "egrep --color=auto";

    ga = "git add"; gap = "git add -p"; gb = "git branch"; gbl = "git branch --list";
    gc = "git checkout"; gcd = "git checkout develop"; gcl = "git clone";
    gcm = "git commit"; gcma = "git commit --amend --no-edit";
    gd = "git diff"; gds = "git diff --staged"; gfind = "git ls-files | grep -i";
    gls   = "git log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate -20";
    glsa  = "git log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate";
    gll = "gls --numstat"; glla = "glsa --numstat";
    glg = "git log --graph --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset\" --abbrev-commit --date=relative";
    gldate     = "git log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=relative";
    gldatelong = "git log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=short";
    gpo = "git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)";
    gpr = "git pull --rebase"; gpull = "git pull"; gpush = "git push";
    gpushf = "git push --force-with-lease";
    grb = "git rebase"; grba = "git rebase --abort"; grbc = "git rebase --continue";
    grbd = "git fetch origin develop:develop ; git rebase develop";
    gs = "git status"; gundo = "git reset HEAD~"; gshow = "git show"; gshowh = "git show HEAD";
    gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m \"[WIP]: $(date)\"";
    gwt = "git worktree";
    gwta = "(){ git worktree add $1 $1;}";
    gwtb = "(){ git worktree add -b $1 $1;}";

    clippy      = " cargo clippy --all-features -- -W clippy::suspicious -W clippy::complexity -W clippy::perf -W clippy::style -W clippy::pedantic -W clippy::correctness";
    clippy-fix  = "cargo clippy --all-features --fix --allow-dirty -- -W clippy::suspicious -W clippy::complexity -W clippy::perf -W clippy::style -W clippy::pedantic -W clippy::correctness && cargo fmt";
    clippy-yolo = "__CARGO_FIX_YOLO=1 cargo clippy --all-features --fix --allow-dirty --broken-code -- -W clippy::suspicious -W clippy::complexity -W clippy::perf -W clippy::style -W clippy::pedantic -W clippy::correctness && cargo fmt";
  };

  home.sessionVariables = rec {
    LANG = "en_GB.UTF8"; EDITOR = "nvim"; VISUAL = "nvim"; PAGER = "less";
    PARINIT = "rTbgqR\\ B=.,\\?_A_a Q=_s\\>|";
    CARGO_HOME = "$HOME/.cargo";
    XDG_CACHE_HOME = "$HOME/.cache"; XDG_CONFIG_HOME = "$HOME/.config";
    CARGO_TARGET_DIR = "${XDG_CACHE_HOME}/cargo/target";
  };

  home.sessionPath = [
    "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.cache/npm/global/bin" "/opt/podman/bin"
  ];
}
