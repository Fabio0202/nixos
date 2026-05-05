{
  description = "My NixOS config with Home Manager, multi-host, and one-user-per-host support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nvim-shell.url = "path:/home/simon/nixos/nvim-shell";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    rose-pine-hyprcursor.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    hyprsettings.url = "github:acropolis914/hyprsettings";
    hyprsettings.inputs.nixpkgs.follows = "nixpkgs-unstable";
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-search-tv-src = {
      url = "github:3timeslazy/nix-search-tv";
      flake = false;
    };
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    whisrs.url = "github:y0sif/whisrs";
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
        ];
      };

      # --- Host abstraction ---
      mkHost = hostName: userName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable self; };

          modules = [
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs pkgs-unstable self;
                nix-search-tv-src = inputs.nix-search-tv-src;
              };
              home-manager.backupFileExtension = "backup";
              home-manager.users.${userName} = mkUser userName hostName;
            }
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
