{
  description = "My NixOS config with Home Manager and multi-host support";

  inputs = {
    nvf.url = "github:notashelf/nvf";
    # TODO: Update to 25.11
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    mkHost = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {inherit inputs;}; # Pass all inputs to modules

        modules = [
          ./hosts/${hostName}/configuration.nix
          home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.fabio = {
              imports = [
                (import ./home/${hostName}.nix)
                inputs.nvf.homeManagerModules.default
              ];
            };
            home-manager.extraSpecialArgs = {inherit inputs;}; # Also pass to home-manager
          }
        ];
      };
  in {
    # Correct nixosConfigurations output
    nixosConfigurations = {
      pc = mkHost "pc";
      laptop = mkHost "laptop";
    };

    # Optional: You can also expose packages if you want
    packages.${system} = {
      # Your custom packages here if any
    };

    # Optional: Development shell
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [pkgs.nixpkgs-fmt];
    };
  };
}
