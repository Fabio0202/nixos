{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "Fabio";
      user.email = "fabiomuscas@gmail.com";

      # how to handle `git pull` when branches diverge
      pull.rebase = false; # or true if you prefer rebase
      pull.ff = "only"; # safer: only fast-forward
    };
  };
}
