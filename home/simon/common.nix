{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    deluge # Lightweight, full-featured BitTorrent client
    speedtest-cli # Test internet bandwidth using speedtest.net
    (pkgs-unstable.devenv) # Dev environment manager (like direnv but more powerful)
    (pkgs-unstable.opencode) # open source code agents
    redis # In-memory data structure store (DB, cache, message broker)
    deno # Modern JavaScript/TypeScript runtime
    lazydocker # TUI for docker
    mdcat # render Markdown in terminal
    lsof # list open files and processes
    vi-mongo # MongoDB shell with vim keybindings
    # rainfrog # a tui for db connections
    docker-compose

    jujutsu # like git but apparently better
    lazyjj
    # Java development here
    # google-java-format
    # jdk17 # Java 17 for Spring Boot
    # gradle # Build tool
    # spring-boot-cli # Optional for project generation
    # maven # Build tool
  ];

  virtualisation.docker.enable = true;

  programs.lazygit = {
    enable = true;
    settings = {
      git.fetchAllInterval = 0; # disables background fetch
    };
  };
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };
  imports = [
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
  ];
}
