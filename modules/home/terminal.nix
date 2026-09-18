{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      keybind = [ "global:opt+space=toggle_quick_terminal" ];
      quick-terminal-animation-duration = 0;
      quick-terminal-position = "bottom";
      window-save-state = "always";

      macos-auto-secure-input = true;
      macos-non-native-fullscreen = true;
      macos-option-as-alt = false;
      macos-secure-input-indication = true;
      macos-titlebar-style = "tabs";

      link-url = true;
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 13;
      background = "#191720";
      foreground = "#e0def4";
      palette = [
        "0=#393552"
        "1=#eb6f92"
        "2=#3e8fb0"
        "3=#f6c177"
        "4=#9ccfd8"
        "5=#c4a7e7"
        "6=#ea9a97"
        "7=#e0def4"
        "8=#59546d"
        "9=#eb6f92"
        "10=#3e8fb0"
        "11=#f6c177"
        "12=#9ccfd8"
        "13=#c4a7e7"
        "14=#ea9a97"
        "15=#e0def4"
      ];
    };
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    baseIndex = 1;
    historyLimit = 100000;
    keyMode = "vi";
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
    ];
    extraConfig = ''
      set -ga terminal-overrides ",*256col*:RGB"
      set -ga terminal-features "*:hyperlinks"
      set -ga terminal-features "*:clipboard"
      set -ga terminal-features "*:focus"
      set -ga terminal-features "*:ccolour"
      set -ga terminal-features "*:cstyle"
      set -g allow-passthrough on

      unbind v
      unbind h
      unbind %
      unbind '"'
      bind v split-window -h -c "#{pane_current_path}"
      bind h split-window -v -c "#{pane_current_path}"

      set-option -s set-clipboard on
      bind P paste-buffer
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'pbcopy'

      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-boot 'on'
      set -g @continuum-restore 'on'

      bind S-Left swap-window -t -1
      bind S-Right swap-window -t +1

      set-option -g status-style fg=yellow,bg=black
      set-window-option -g window-status-style fg=brightblue,bg=default
      set-window-option -g window-status-current-style fg=brightred,bg=default
      set-option -g pane-border-style fg=black
      set-option -g pane-active-border-style fg=brightgreen
      set-option -g message-style fg=brightred,bg=black
      set-option -g display-panes-active-colour blue
      set-option -g display-panes-colour red
      set-window-option -g clock-mode-colour green
      set-window-option -g window-status-bell-style fg=black,bg=red

      bind T neww -c "#{pane_current_path}" "[[ -e todo.md ]] && nvim todo.md || nvim ~/Documents/todo.md"
      bind-key f neww ~/.local/bin/tmux-sessioniser
      bind-key V neww nvim
      bind C-c attach-session -c "#{pane_current_path}"
      bind C new-window -c "#{pane_current_path}"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      status.disabled = false;
      username = {
        show_always = true;
        style_user = "bg:#9A348E";
        style_root = "bg:#9A348E";
        format = "[$user ]($style)";
        disabled = false;
      };
      os = {
        style = "bg:#9A348E";
        disabled = true;
      };
      directory = {
        style = "bg:#DA627D";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = " ";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };
      c = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      docker_context = {
        symbol = " ";
        style = "bg:#06969A";
        format = "[ $symbol $context ]($style) $path";
      };
      elixir = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      elm = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      git_branch = {
        symbol = "";
        style = "bg:#FCA17D";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "bg:#FCA17D";
        format = "[$all_status$ahead_behind ]($style)";
      };
      golang = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      gradle = {
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      haskell = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      java = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      julia = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      nodejs = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      nim = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      rust = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      scala = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#33658A";
        format = "[ ♥ $time ]($style)";
      };
      nix_shell = {
        disabled = false;
        symbol = "❄";
        format = "[$symbol](bold blue)";
      };
    };
  };
}
