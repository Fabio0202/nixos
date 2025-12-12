{ pkgs, ... }:
let
  scriptDir = ../scripts;

  # Turn every .sh file in home/scripts into a binary in $PATH
  scriptBins = builtins.listToAttrs (map
    (name: {
      name = builtins.replaceStrings [ ".sh" ] [ "" ] name;
      value =
        pkgs.writeShellScriptBin (builtins.replaceStrings [ ".sh" ] [ "" ] name)
          (builtins.readFile (scriptDir + "/${name}"));
    })
    (builtins.attrNames (builtins.readDir scriptDir)));
in
{
  home.packages = builtins.attrValues scriptBins;
}
