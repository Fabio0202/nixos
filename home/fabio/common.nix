{pkgs, ...}: {
  home.packages = with pkgs; [
    # sachen die du auf ALLEN geraten haben willst (server inklusive)
  ];

  imports = [
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
  ];
}
