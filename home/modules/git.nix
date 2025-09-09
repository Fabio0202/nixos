{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Simon Muscas";
    userEmail = "you@example.com"; # change this

    extraConfig = {
      # how to handle `git pull` when branches diverge
      pull.rebase = false; # or true if you prefer rebase
      pull.ff = "only"; # safer: only fast-forward
    };
  };
}
