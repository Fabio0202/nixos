# NixOS Configuration - Agent Guidelines

## Build/Lint/Test Commands
- `nix flake check` - Validate flake and all configurations
- `nix develop` - Enter dev shell with formatting tools
- `nixpkgs-fmt **/*.nix` - Format all Nix files
- `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` - Build specific host configuration

## ⚠️ CRITICAL RESTRICTIONS - NEVER RUN THESE COMMANDS
- **NEVER** run `nixos-rebuild switch` under any circumstances
- **NEVER** run `home-manager switch` under any circumstances  
- **NEVER** run any `git` or `jj` commands - you are not allowed to use version control

## Code Style Guidelines

### File Structure
- Use explicit attribute set parameters: `{pkgs, inputs, ...}:`
- Place imports at the top using relative paths
- Separate system (`hosts/`) and user (`home/`) configurations
- Use kebab-case for filenames, camelCase for variables

### Import Patterns
```nix
{pkgs, inputs, ...}: {
  imports = [
    ./module.nix
    ../modules/common-module.nix
  ];
}
```

### Configuration Organization
- Group related configurations (home.packages, programs.*, services.*)
- Use `with pkgs;` for package lists
- Maintain consistent indentation (2 spaces)
- Add comments only for non-obvious configurations

### Naming Conventions
- Files: kebab-case (`hyprlandWM.nix`, `battery-monitor.nix`)
- Variables: camelCase (`mainMod`, `userName`)
- Modules: descriptive and purpose-specific

### Error Handling
- Use `lib.optionalAttrs` for conditional configurations
- Implement proper type checking with `lib.types`
- Validate configurations in `flake.nix` checks

## Repository Structure
- `hosts/` - System-level NixOS configurations
- `home/` - Home Manager user configurations  
- `modules/` - Shared configuration modules
- `flake.nix` - Main flake with `mkHost` and `mkUser` functions