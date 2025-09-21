{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    deluge # Lightweight, full-featured BitTorrent client
    gh
    (pkgs-unstable.devenv) # Dev environment manager (like direnv but more powerful)
    redis
    direnv # Manage environment variables per project directory
    mdcat # render Markdown in terminal
    lsof # list open files and processes
    # rainfrog # a tui for db connections

    # Java development here
    # google-java-format
    # jdk17 # Java 17 for Spring Boot
    # gradle # Build tool
    # spring-boot-cli # Optional for project generation
    # maven # Build tool
  ];

  programs = {
    awscli = {
      enable = true;
      package = pkgs.awscli2; # v2 is recommended
    };
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
