{...}: {
  home.file.".cache/ags/hyprpanel" = {
    source = builtins.path {path = ../configfiles/hyprpanel;};
    recursive = true;
  };
}
