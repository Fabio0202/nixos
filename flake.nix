{
  description = "My NixOS config with Home Manager, multi-host, and one-user-per-host support";

  inputs = {
    nvf.url = "github:notashelf/nvf";

    # TODO: Update to 25.11 when stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland"; # 👈 ensures ABI match
    };

    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland"; # ensures ABI matches Hyprland
    };
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
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

    # --- User abstraction ---
    mkUser = hostName: {
      imports = [
        ./home/common.nix
        ./home/${hostName}.nix
        inputs.nvf.homeManagerModules.default
      ];
    };

    # --- Host abstraction ---
    mkHost = hostName: userName:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};

        modules = [
          ./hosts/${hostName}/configuration.nix
          home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};

            home-manager.backupFileExtension = "backup";
            # only configure HM for the user that belongs on this host
            home-manager.users.${userName} = mkUser hostName;
          }
        ];
      };
  in {
    # --- Hosts ---
    nixosConfigurations = {
      pc = mkHost "pc" "fabio";
      laptop = mkHost "laptop" "fabio";
      simon-laptop = mkHost "simon-laptop" "simon";
    };

    # --- Optional packages ---
    packages.${system} = {};

    # --- Dev shell ---
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [pkgs.nixpkgs-fmt];
    };
  };
}
