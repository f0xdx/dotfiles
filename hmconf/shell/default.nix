{ config, pkgs, lib, theme, ...}:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = builtins.fromTOML (builtins.readFile ./cfg/starship.toml);
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      # enableFlakes = true;
    };
  };

  programs.bash = {
    enable = true;

    historyControl = [ 
      "erasedups"
      "ignorespace"
      "ignoredups"
    ];
    historyIgnore = [
      "ls"
      "exit"
    ];

    shellOptions = [
      "extglob"
      "histappend"
    ];

    initExtra = ''
      _fzf_setup_completion path eza lsx bat nvim.sh
    '';

    # note: can also source complete files like this
    # initExtra = ''
    #   . ~/projects/dotfiles/bash/bashrc
    # '';
  };

  programs.readline = {
    enable = true;
    bindings = {
      "\\t" =   "menu-complete";
      "\\e[Z" = "menu-complete-backward";
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
    variables = {
      editing-mode = "vi";
      colored-completion-prefix =    true;
      colored-stats =                true;
      menu-complete-display-prefix = true;
      show-all-if-ambiguous =        true;
      completion-ignore-case =       true;
    };
  };

  programs.fd = {
    enable = true;
  };
  
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;

    # configures alt-c command
    changeDirWidgetCommand = "fd --type d --hidden --color always --exclude .git";
    changeDirWidgetOptions = [
      # TODO $LINES arithmetic not working
      "--preview 'exa -T -L1 --color always --icons -s name --group-directories-first {} | sed \\\"$(( $LINES-1 ))s/.*/.../; $LINES,$ d\\\"'"
      "--ansi"
      "--height 40%"
    ];

    # configures default command
    defaultCommand = "fd --hidden --color always --exclude .git";
    defaultOptions =[
      "--ansi"
      "--height 40%"
    ];

    # configures ctrl-t command
    fileWidgetCommand = "fd --type f --hidden --color always --exclude .git";
    fileWidgetOptions = [
      "--ansi"
      "--preview 'bat --style=numbers,changes --color=always --line-range=:$LINES {}'"
      "--height 40%"
    ];

    historyWidgetOptions = [
      "--tac"
      "--height 40%"
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  programs.tmux = {
    enable = true;

    historyLimit = 10000;
    escapeTime = 12;
    terminal = "screen-256color";
    keyMode = "vi";
    baseIndex = 1;
    
    customPaneNavigationAndResize = true;
    clock24 = true;

    plugins = with pkgs.tmuxPlugins; [
      yank
      open
      sessionist
      vim-tmux-navigator
      # tmux-modus-theme
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }

    ];

    extraConfig = let
      statusBarTheme = if theme == "modus-operandi" then
      ''
        set-option -g status-style bg=#e6e6e6,fg=#0a0a0a
        set-window-option -g window-status-current-style fg=#3548cf
      '' else
      ''
        set-option -g status-style bg=#2d2d2d,fg=#f0f0f0
        set-window-option -g window-status-current-style fg=#79a8ff 
      '';
    in
    ''
      # Set XTerm key bindings
      setw -g xterm-keys on
      
      # Set colors
      set -ga terminal-overrides ",xterm-256color:RGB"
      
      # Enable focus-events to enable vim to refresh accordingly.
      set-option -g focus-events on
      
      
      set -g mouse on
      
      # Resize the current pane using Alt + direction
      # those might not work on mac
      bind -n M-k resize-pane -U
      bind -n M-j resize-pane -D
      bind -n M-h resize-pane -L
      bind -n M-l resize-pane -R
      
      # Open new panes and windows in current directory.
      bind '|' split-window -h -c '#{pane_current_path}'
      bind '-' split-window -v -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'
      
      
      # Enable pbcopy/pbpaste in tmux.
      if-shell \
        'test "$(uname -s)" = Darwin && type reattach-to-user-namespace > /dev/null' \
      'set-option -g default-command "exec reattach-to-user-namespace -l zsh"'
      
      # status bar
      set-option -g status-position top
      bind b set-option -g status

      # status line style
      set-option -g status-left "#{session_name}   "
      #set-option -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %d-%b-%y"
      set-option -g status-right "{} #{=21:pane_title} %H:%M"
      set-option -g window-status-format "#W"
      set-option -g window-status-current-format "#W"
      
      # TODO change this to the modus theme once location is known
      #set-window-option -g window-status-current-style bg=yellow,fg=black
    '' + statusBarTheme; 
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = true;
    git = true;
    extraOptions = [
      "--group-directories-first"
    ];
  };
}