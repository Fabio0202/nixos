{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Node + package managers
    nodejs_22 # or nodejs_latest if you want bleeding edge
    corepack # gives you npm, yarn, pnpm, npx automatically
    yarn

    # Deno runtime
    deno
  ];
}
