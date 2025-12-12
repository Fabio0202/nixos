{
  description = "My NixOS config with Home Manager, multi-host, and one-user-per-host support";

  inputs = {
    nvf.url = "github:notashelf/nvf/v0.8";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    hyprtasking = {
      url = "github:raybbian/hyprtasking";
      inputs.hyprland.follows = "hyprland";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };


    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";

      # Import nixpkgs with allowUnfree so we can import proprietary software
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Import nixpkgs-unstable channel with allowUnfree so we can import proprietary software
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # --- User abstraction ---
      mkUser = userName: hostName: {
        home = {
          username = userName;
          homeDirectory = "/home/${userName}";
          stateVersion = "25.11"; # pin Home Manager release compatibility
        };
        imports = [
          ./home/${userName}/${hostName}.nix
          inputs.nvf.homeManagerModules.default
        ];
      };

      # --- Host abstraction ---
      mkHost = hostName: userName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };

          modules = [
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
              home-manager.backupFileExtension = "backup";
              home-manager.users.${userName} = mkUser userName hostName;
            }
            inputs.stylix.nixosModules.stylix
          ];
        };
    in
    {
      # --- Hosts ---
      nixosConfigurations = {
        fabio-pc = mkHost "fabio-pc" "fabio";
        fabio-laptop-hp = mkHost "fabio-laptop-hp" "fabio";
        fabio-laptop-lenovo = mkHost "fabio-laptop-lenovo" "fabio";
        simon-laptop = mkHost "simon-laptop" "simon";
        simon-pc = mkHost "simon-pc" "simon";
        server = mkHost "server" "simon";
        server-wien = mkHost "server-wien" "fabio";
      };

      # --- Optional packages ---
      packages.${system} = { };

      # --- Dev shell ---
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nixpkgs-fmt
        ];
      };
    };
}
