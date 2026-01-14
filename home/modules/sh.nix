{
  config,
  lib,
  pkgs,
  ...
}: {
  # to make sure global npm packages and local binaries are accessible
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
  ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf.enable = true;
  programs.fish.enable = false;

  programs.zsh.initExtraBeforeCompInit = ''
    export PATH="$HOME/.npm-global/bin:$PATH"
  '';
  programs.zsh.initExtra = ''
    source ~/.p10k.zsh
    source ~/.zsh/aliases.zsh

    function fzf() {
      local selected_file
      selected_file=$(command fzf) || return
      xdg-open "$selected_file"
    }

    function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 20000;
      size = 20000;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  home.file.".p10k.zsh".source = ./p10k-config/p10k.zsh;
  programs.zsh = {
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    # Fun / misc
    haskellPackages.misfortune # random fortune messages (misfortune quotes)
    cowsay # display messages as ASCII cows
    lolcat # rainbow-colorize terminal output
    neofetch # system info in terminal (with ASCII logo)
    # Task / time management
    taskwarrior3 # CLI task manager
    timewarrior # CLI time tracking
    taskwarrior-tui # ncurses interface for taskwarrior
    # Search / navigation
    fzf # fuzzy finder (search lists interactively)
    jq # process/manipulate JSON in terminal
    eza # modern replacement for ls
    ripgrep # fast grep-like search tool
    zoxide # smarter cd with directory jumping
    lf # terminal file manager
    gping # ping with graph output
    # System / utilities
    btop # resource monitor (CPU, RAM, GPU, etc.)
    wget # download files from web
    xclip # clipboard CLI for X11/Wayland
    kitty # GPU-accelerated terminal - moved to stow
    bat # modern replacement for cat (with syntax highlighting)
    trash-cli # move files to trash instead of rm
    yazi # fast TUI file manager (like lf but modern)
    # Build tools / dev utils
    gnumake # build automation (needed by many projects)
    cmake # cross-platform build system
    gcc # C/C++ compiler
  ];
}
