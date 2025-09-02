{
  description = "My NixOS config with Home Manager and multi-host support";

  inputs = {
    nvf.url = "github:notashelf/nvf";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel"; # Notifications und so sachen
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };  # stylix ist da, um alles gleich aussehen yu lassen
    hyprland.url = "github:hyprwm/Hyprland"; # Windowmanager
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      mkHost = hostName: {
        nixosSystem = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fabio = import ./home/${hostName}.nix;
            }
          ];

          # Explicitly expose nixos-rebuild if needed
          config.system.build.nixos-rebuild = import nixpkgs.nixosModules.nixos-rebuild;
        };
      };
    in
    {
      # Define configurations for each host
      nixosConfigurations.pc = mkHost "pc";
      nixosConfigurations.laptop = mkHost "laptop";

      # Now expose the correct nixosConfigurations for use by other flake commands
      packages.x86_64-linux = nixpkgs.lib.mkDerivation {
        name = "nixosConfigurations";
        buildInputs = [];
        # You could define the outputs you want to share here, like:
        outputs = nixosConfigurations;
      };

      legacyPackages.x86_64-linux = nixpkgs.lib.mkDerivation {
        name = "legacy-nixosConfigurations";
        buildInputs = [];
        # Also expose legacyPackages
        outputs = nixosConfigurations;
      };
    };
}
