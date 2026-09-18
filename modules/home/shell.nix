{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidget.command = "";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = false;
      update_check = false;
      filter_mode = "directory";
      search_mode = "daemon-fuzzy";
      search = {
        recency_score_multiplier = 10;
        frecency_score_multiplier = 2;
      };
      daemon = {
        enabled = true;
        autostart = true;
      };
      tmux.enabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    history = {
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
    };
    initContent = ''
      setopt functionargzero globdots
      bindkey -s '^F' 'tmux-sessioniser\n'
      ulimit -n 10240

      # Clone a bare repository prepared for Git worktrees.
      __git_worktree_clone() {
        if [ $# -eq 0 ]; then
          echo "No arguments supplied, must supply clonable URI."
          return 1
        fi

        if [ -z "$2" ]; then
          dir_name=$(basename "$1") || return 1
        else
          dir_name=$2
        fi

        mkdir -p "$dir_name" && pushd "$dir_name" > /dev/null || return 1
        git clone --bare "$1" .bare 2>&1 | sed "s|\\.bare|''${dir_name}|g"
        echo "gitdir: ./.bare" > .git
        popd > /dev/null
      }

      [[ -r "$HOME/.config/op/plugins.sh" ]] && source "$HOME/.config/op/plugins.sh"
    '';
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.shellAliases = {
    ls = "eza";
    ll = "eza -alh";
    la = "eza -a";
    l = "eza";
    lld = "eza -alh --group-directories-first";
    ld = "eza --group-directories-first";
    so = "source";
    python = "python3";
    py = "python";
    py_pdb = "python -m pdb -c continue";
    pip = "pip3";
    sshx = "ssh -X";
    sshy = "ssh -Y";
    f = "find . -name ";
    grep = "grep --color=auto";
    fgrep = "fgrep --color=auto";
    egrep = "egrep --color=auto";

    ga = "git add";
    gap = "git add -p";
    gb = "git branch";
    gbl = "git branch --list";
    gc = "git checkout";
    gcd = "git checkout develop";
    gcl = "git clone";
    gcm = "git commit";
    gcma = "git commit --amend --no-edit";
    gd = "git diff";
    gds = "git diff --staged";
    gfind = "git ls-files | grep -i";
    gls = "git log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate -20";
    glsa = "git log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate";
    gll = "gls --numstat";
    glla = "glsa --numstat";
    glg = "git log --graph --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset\" --abbrev-commit --date=relative";
    gldate = "git log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=relative";
    gldatelong = "git log --pretty=format:\"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --date=short";
    gpo = "git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)";
    gpr = "git pull --rebase";
    gpull = "git pull";
    gpush = "git push";
    gpushf = "git push --force-with-lease";
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbd = "git fetch origin develop:develop ; git rebase develop";
    gs = "git status";
    gundo = "git reset HEAD~";
    gshow = "git show";
    gshowh = "git show HEAD";
    gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m \"[WIP]: $(date)\"";
    gwt = "git worktree";
    gwta = "(){ git worktree add $1 $1;}";
    gwtb = "(){ git worktree add -b $1 $1;}";
    gclb = "__git_worktree_clone";

    clippy = " cargo clippy --all-features -- -W clippy::suspicious -W clippy::complexity -W clippy::perf -W clippy::style -W clippy::pedantic -W clippy::correctness";
    clippy-fix = "cargo clippy --all-features --fix --allow-dirty -- -W clippy::suspicious -W clippy::complexity -W clippy::perf -W clippy::style -W clippy::pedantic -W clippy::correctness && cargo fmt";
    clippy-yolo = "__CARGO_FIX_YOLO=1 cargo clippy --all-features --fix --allow-dirty --broken-code -- -W clippy::suspicious -W clippy::complexity -W clippy::perf -W clippy::style -W clippy::pedantic -W clippy::correctness && cargo fmt";
  };

  home.sessionVariables = rec {
    LANG = "en_GB.UTF8";
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    PARINIT = "rTbgqR\\ B=.,\\?_A_a Q=_s\\>|";
    CARGO_HOME = "$HOME/.cargo";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    CARGO_TARGET_DIR = "${XDG_CACHE_HOME}/cargo/target";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.cache/npm/global/bin"
    "/opt/podman/bin"
  ];
}
