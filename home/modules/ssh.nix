{ config
, lib
, pkgs
, ...
}:
let
  myHosts = {
    salzburg-server = {
      ip = "100.91.43.74";
      user = "edin";
    };

    simon-laptop = {
      ip = "100.111.190.86";
      user = "simon";
    };
  };
in
{
  programs.ssh = {
    enable = true;

    matchBlocks =
      lib.mapAttrs
        (name: h: {
          hostname = h.ip;
          user = h.user;
          forwardX11 = true;
          forwardX11Trusted = true;
        })
        myHosts;
  };
}
