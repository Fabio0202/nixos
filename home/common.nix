{
    pkgs, ...
}:
{
    home.packages = with pkgs; [
        syncthing
        libreoffice
        unzip
        ffmpeg
        # libnotify
        lazygit
    ];
    imports = [
        # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
    ];
}