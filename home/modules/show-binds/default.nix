{
  pkgs,
  lib,
  config,
  ...
}: {
  home.activation.generateKeybindsJson = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "[HM] Running generateKeybindsJson…" >> /tmp/hm-keybinds.log
    mkdir -p ${config.home.homeDirectory}/.show-binds
    ${pkgs.deno}/bin/deno run --allow-read --allow-write \
      ${./keybinds2json.ts} \
      ${../hyprland/config/keybinds.nix} \
      ${config.home.homeDirectory}/.show-binds/keybinds.json \
      >> /tmp/hm-keybinds.log 2>&1
  '';
}
