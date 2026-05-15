# BFME2 on NixOS — Complete Setup Guide

## Overview

The Lord of the Rings: The Battle for Middle-earth II (BFME2) is a 2006 RTS game by EA Los Angeles using the SAGE engine. It's abandonware — EA lost the LOTR license and delisted it. There is no digital storefront purchase; you need original discs or ISOs.

**Feasibility verdict: FEASIBLE but involved.** The game runs well under Wine on Linux. Multiplayer with friends is possible via T3A:Online (dedicated fan server replacement for the defunct GameSpy) *or* via LAN-over-VPN (Tailscale/Hamachi). The biggest pain points are: DRM bypass, patch installation order, and the manual `options.ini` creation. All of these can be automated in a NixOS flake.

---

## 1. The Problems (and How We Solve Them)

| Problem | Solution |
|---|---|
| **SafeDisc DRM** doesn't work on Vista+ | Unofficial 1.09 patch includes a no-CD crack |
| **Auto-defeat after 3:30** (DRM sabotage) | Fixed by 1.09 patch or 2.02 patch |
| **GameSpy shutdown** — no official online | T3A:Online replaces the server; or use LAN mode |
| **No `options.ini`** created by installer | Must manually create it (scriptable) |
| **Game path depends on locale** (German installs use different folder names) | Symlink/create expected English paths |
| **Widescreen support** | 1.09 patch adds proper widescreen; or edit `options.ini` |
| **Off-host delay in multiplayer** | Fixed in RotWK 2.02 v9.0.0+; no fix for base BFME2 |
| **Frame rate locked at 30 FPS** | Game speed is tied to frame rate; no clean fix |
| **Wine compatibility** | Works with 32-bit Wine prefix; Lutris has verified installers |

---

## 2. Multiplayer Options Compared

### Option A: T3A:Online (Recommended for Internet Play)

- Free fan-hosted server at https://t3aonline.net
- Replaces the old GameSpy service
- Integrates into the game's built-in online menu
- Requires: T3A:Online Launcher (Windows .msi), account registration at t3aonline.net
- Works under Wine (launcher is a .NET app)
- **Best for: Playing with randoms or friends over the internet without VPN**

### Option B: LAN Mode + Tailscale (Recommended for Friends-Only)

- BFME2 supports direct LAN play (up to 8 players)
- Use Tailscale to create a virtual LAN
- UDP port **16000** must be open on the hosting machine
- Advantage: No third-party game server dependency
- **Best for: Playing with a fixed group of friends**

### Option C: LAN Mode + Hamachi/LogMeIn

- Same as Tailscale but using Hamachi
- Hamachi has a Linux client but is proprietary
- **Less recommended** — Tailscale is easier on NixOS and is in nixpkgs

### Option D: GameRanger

- GameRanger is a Windows-only matchmaking client
- Works under Wine but is the most brittle option
- **Not recommended on NixOS**

### Verdict

- **For casual play with friends**: Tailscale + LAN is the simplest and most reliable
- **For broader community**: T3A:Online
- **Both can coexist** — nothing prevents using both methods

---

## 3. NixOS Flake Setup

### 3.1 Add a BFME2 Flake Package

Create `packages/bfme2/default.nix`:

```nix
{ pkgs, ... }:

let
  # The game needs a 32-bit Wine prefix
  wine' = pkgs.wineWowPackages.staging;

  # Helper script to launch BFME2
  bfme2-launch = pkgs.writeShellApplication {
    name = "bfme2-launch";
    runtimeInputs = [ wine' ];
    text = ''
      export WINEPREFIX="''${WINEPREFIX:-$HOME/.local/share/bfme2/wine-prefix}"
      export WINEARCH=win32

      # Create prefix if it doesn't exist
      if [ ! -d "$WINEPREFIX" ]; then
        wineboot --init
        # Wait for wineboot to finish
        wineserver -w
      fi

      # Ensure options.ini exists
      OPTIONS_DIR="$WINEPREFIX/drive_c/users/$(whoami)/Application Data/My Battle for Middle-earth(tm) II Files"
      mkdir -p "$OPTIONS_DIR"
      if [ ! -f "$OPTIONS_DIR/options.ini" ]; then
        cat > "$OPTIONS_DIR/options.ini" << 'EOF'
    AudioLOD = High
    FlashTutorial = 0
    HasSeenLogoMovies = yes
    IdealStaticGameLOD = High
    Resolution = 1920 1080
    StaticGameLOD = High
    TimesInGame = 6
    EOF
      fi

      # Launch the game
      GAME_DIR="''${BFME2_GAME_DIR:-$WINEPREFIX/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II}"
      wine "$GAME_DIR/lotrbfme2.exe" "''$@"
    '';
  };

  # Helper script to launch the Patch Switcher
  bfme2-patch-switcher = pkgs.writeShellApplication {
    name = "bfme2-patch-switcher";
    runtimeInputs = [ wine' ];
    text = ''
      export WINEPREFIX="''${WINEPREFIX:-$HOME/.local/share/bfme2/wine-prefix}"
      export WINEARCH=win32
      wine "$WINEPREFIX/drive_c/Program Files/BFME2 PatchSwitcher/BFME2 PatchSwitcher.exe"
    '';
  };

  # Helper script to launch T3A:Online
  bfme2-t3a-online = pkgs.writeShellApplication {
    name = "bfme2-t3a-online";
    runtimeInputs = [ wine' ];
    text = ''
      export WINEPREFIX="''${WINEPREFIX:-$HOME/.local/share/bfme2/wine-prefix}"
      export WINEARCH=win32
      wine "$WINEPREFIX/drive_c/Program Files/T3AOnline/T3AOnline.exe" "''$@"
    '';
  };

in {
  inherit wine' bfme2-launch bfme2-patch-switcher bfme2-t3a-online;
}
```

### 3.2 Add to Your flake.nix

Add a package output to your `flake.nix`:

```nix
# Inside your outputs, add to the packages.${system} set:
packages.${system} = {
  bfme2-launch = self.packages.${system}.bfme2-launch;
  bfme2-patch-switcher = self.packages.${system}.bfme2-patch-switcher;
  bfme2-t3a-online = self.packages.${system}.bfme2-t3a-online;
};
```

### 3.3 NixOS Module for Tailscale + Firewall

Create `hosts/modules/tailscale-gaming.nix`:

```nix
{ config, lib, pkgs, ... }:

# Opens the BFME2 LAN port through the firewall for Tailscale interface only
# Assumes services.tailscale is already enabled elsewhere
{
  networking.firewall.interfaces.tailscale0 = {
    allowedUDPPorts = [ 16000 ];
  };
}
```

### 3.4 Home Manager Package Installation

Add the Wine packages and helper scripts to your home config (e.g., `home/simon/common-gui.nix`):

```nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wineWowPackages.staging
    winetricks
  ];
}
```

Or alternatively, install only the minimal 32-bit Wine:

```nix
{ pkgs, ... }:
{
  home.packages = [
    pkgs.wineWowPackages.staging
    pkgs.winetricks
  ];
}
```

---

## 4. Step-by-Step Installation

### Phase 1: Install the Base Game

1. **Obtain the game ISO** — You need original BFME2 discs or the community-provided ISOs from T3A:Online downloads page: https://t3aonline.net/download/

2. **Set up the Wine prefix:**
   ```bash
   export WINEPREFIX="$HOME/.local/share/bfme2/wine-prefix"
   export WINEARCH=win32
   wineboot --init
   wineserver -w
   ```

3. **Mount the ISO and install:**
   ```bash
   sudo mkdir -p /mnt/bfme2
   sudo mount -o loop ~/path/to/BFME2.iso /mnt/bfme2
   wine /mnt/bfme2/AutoRun.exe
   ```
   
   - Install to the default path: `C:\Program Files\Electronic Arts\The Battle for Middle-earth (tm) II`
   - Choose **English** as the language (avoids locale path issues)
   
4. **Unmount:**
   ```bash
   sudo umount /mnt/bfme2
   ```

### Phase 2: Fix the Game Path (if non-English install)

If the installer created a localized folder name instead of the English one:

```bash
cd "$WINEPREFIX/drive_c/Program Files/Electronic Arts/"
# Find the actual directory
ls
# Create a symlink if needed
ln -s "Schlacht um Mittelerde(tm) II" "The Battle for Middle-earth (tm) II"
```

Same for AppData:
```bash
cd "$WINEPREFIX/drive_c/users/$(whoami)/Application Data/"
# Symlink if needed
ln -s "Meine Schlacht um Mittelerde(tm) II Dateien" "My Battle for Middle-earth(tm) II Files"
```

### Phase 3: Create `options.ini` (CRITICAL — game won't start without this)

```bash
OPTIONS_DIR="$WINEPREFIX/drive_c/users/$(whoami)/Application Data/My Battle for Middle-earth(tm) II Files"
mkdir -p "$OPTIONS_DIR"
cat > "$OPTIONS_DIR/options.ini" << 'EOF'
AudioLOD = High
FlashTutorial = 0
HasSeenLogoMovies = yes
IdealStaticGameLOD = High
Resolution = 1920 1080
StaticGameLOD = High
TimesInGame = 6
EOF
```

### Phase 4: Install the Unofficial 1.09 Patch (REQUIRED)

This patch is **essential** — it bypasses DRM, fixes the auto-defeat bug, and adds widescreen support.

1. Download the **BFME2 All-In-One Patch Switcher** from:
   - https://github.com/ValheruGR/BFME2/releases (Mirror 4)
   - Or: https://www.gamereplays.org/battleformiddleearth2/portals.php?show=page&name=bfme2-patch-1.09

2. Run the installer:
   ```bash
   wine ~/Downloads/FULL_SWITCHER.exe
   ```
   
3. In the Patch Switcher, select **version 1.09** (or 1.09 v3.0 for the latest)
4. The switcher includes:
   - No-CD crack (game doesn't need the disc)
   - Auto-defeat fixer
   - Widescreen resolution support
   - Out-of-memory error fix (in v2+)
   - Zoom-out option

### Phase 5: (Optional) Install HD Mod

Download from: https://www.moddb.com/mods/battle-for-middle-earth-2-hd-edition

```bash
wine ~/Downloads/HDEditionInstaller.exe
```

Launch the game with the `-mod` flag:
```bash
wine "$WINEPREFIX/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe" -mod "$WINEPREFIX/drive_c/users/$(whoami)/Application Data/My Battle for Middle-earth(tm) II Files/HDEdition.big"
```

### Phase 6: (Optional) Install Rise of the Witch-king Expansion

1. Mount the RotWK ISO and install:
   ```bash
   sudo mount -o loop ~/path/to/RotWK.iso /mnt/rotwk
   wine /mnt/rotwk/AutoRun.exe
   ```

2. **IMPORTANT**: If using RotWK, use patch version **1.06** for the base game (not 1.09), then install the unofficial **2.02 patch** for RotWK:
   - https://www.gamereplays.org/riseofthewitchking/portals.php?show=page&name=unofficial-patch-202-download-page
   - Source code: https://gitlab.com/forlongthefat/rotwk-unofficial-202
   - **2.02 v9.0.0+ fixes the off-host delay bug in multiplayer!**

---

## 5. Multiplayer Setup

### Method 1: T3A:Online (Internet Play)

1. **Register** at https://t3aonline.net/connect/register/
2. **Create a server login** at https://t3aonline.net/account/create/
3. **Download and install the T3A:Online Launcher:**
   ```bash
   wine ~/Downloads/T3AOnline_2.1.3.msi
   ```
   Or just run:
   ```bash
   msiexec /i ~/Downloads/T3AOnline_2.1.3.msi
   ```

4. **Launch the game via the T3A launcher** or launch BFME2 normally and use the in-game online menu
5. Log in with your server login name + password (NOT your Revora account password)
6. **Port forwarding**: UDP 16000 must be open on your router if hosting

**For NixOS firewall:**
```nix
# Only needed if you're hosting and NOT using Tailscale
networking.firewall.allowedUDPPorts = [ 16000 ];
```

### Method 2: Tailscale LAN Play (Recommended for Friends)

1. **Install Tailscale on NixOS:**
   ```nix
   # In your host configuration.nix:
   services.tailscale.enable = true;
   ```

2. **Authenticate:**
   ```bash
   sudo tailscale up
   ```

3. **Have all friends install Tailscale** (available for Windows, Mac, Linux, etc.)

4. **Open UDP 16000 on the Tailscale interface:**
   ```nix
   networking.firewall.interfaces.tailscale0 = {
     allowedUDPPorts = [ 16000 ];
   };
   ```

5. **One player hosts** a LAN game in BFME2
6. **Other players join** using the host's Tailscale IP (found via `tailscale ip -4`)
7. BFME2's LAN browser should auto-discover games on the virtual network

**For Windows friends on Tailscale:** They just install Tailscale for Windows, and it creates a virtual network adapter that BFME2 can see for LAN discovery.

### Method 3: Hamachi (Alternative VPN)

```nix
# Hamachi is not in nixpkgs but can be installed manually
# Not recommended — Tailscale is easier to manage on NixOS
```

---

## 6. Day-to-Day Launch Commands

```bash
# Set these once in your shell profile or .bashrc
export WINEPREFIX="$HOME/.local/share/bfme2/wine-prefix"
export WINEARCH=win32

# Launch BFME2
wine "$WINEPREFIX/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe"

# Launch with windowed mode
wine "$WINEPREFIX/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe" -win

# Launch with custom resolution
wine "$WINEPREFIX/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe" -xres 2560 -yres 1440

# Launch Patch Switcher
wine "$WINEPREFIX/drive_c/Program Files/BFME2 PatchSwitcher/BFME2 PatchSwitcher.exe"

# Launch with HD Mod
wine "$WINEPREFIX/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe" -mod "$WINEPREFIX/drive_c/users/$(whoami)/Application Data/My Battle for Middle-earth(tm) II Files/HDEdition.big"
```

Or create a `.desktop` file:

```ini
[Desktop Entry]
Name=BFME2
Exec=sh -c 'WINEPREFIX="$HOME/.local/share/bfme2/wine-prefix" WINEARCH=win32 wine "$HOME/.local/share/bfme2/wine-prefix/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe"'
Type=Application
Categories=Game;
```

---

## 7. The NixOS FHS Problem (And How to Solve It)

NixOS doesn't follow the standard Linux filesystem hierarchy (`/usr/bin`, `/usr/lib`, etc.). Wine on NixOS works for running Windows `.exe` files directly, but **installers and helper tools** (winetricks, the Patch Switcher, T3A:Online launcher) often shell out to system commands or expect standard Linux paths. This will cause cryptic failures.

**You WILL need one of these solutions:**

### Option A: `steam-run` (Simplest — Recommended)

`steam-run` provides a pre-built FHS namespace with standard Linux paths. Just install it and prefix your Wine commands:

```nix
# In home/simon/common-gui.nix or similar:
home.packages = with pkgs; [
  steam-run
  wineWowPackages.staging
  winetricks
];
```

Then run any installer or tool through it:
```bash
# Installers
steam-run wine ~/Downloads/FULL_SWITCHER.exe
steam-run msiexec /i ~/Downloads/T3AOnline_2.1.3.msi

# Game launch
steam-run wine "$WINEPREFIX/drive_c/Program Files/Electronic Arts/The Battle for Middle-earth (tm) II/lotrbfme2.exe"

# winetricks
steam-run winetricks d3dx9
```

This is the path of least resistance. The FHS namespace `steam-run` provides covers virtually everything Wine and its tooling needs.

### Option B: `buildFHSUserEnv` (Most Correct — But Tedious to Get Right)

You *can* create a custom FHS environment, but it's hard to get the dependency list right. I initially wrote a compact list of packages — that was **wrong**. Look at what `steam-run` actually includes: **515 packages** spanning glibc, mesa, libglvnd, SDL, audio libs, systemd, udev, GTK, DBus, etc. A hand-picked list like `libgcc libpng zlib` will miss most of what Wine and its tooling actually need at runtime.

Here's a realistic FHS env that pulls in the same foundation `steam-run` uses, plus Wine-specific tools:

```nix
# In packages/bfme2/default.nix or similar:
{ pkgs, ... }:

pkgs.buildFHSUserEnv {
  name = "bfme2-env";
  targetPkgs = pkgs: (with pkgs; [
    wineWowPackages.staging
    winetricks
    cabextract
    p7zip
    unrar
    curl
    zenity
    # These are the most critical ones steam-run includes that Wine needs:
    mesa
    libglvnd
    vulkan-loader
    vulkan-tools
    alsa-lib
    libpulseaudio
    pipewire
    OpenAL
    libsndfile
    libvorbis
    libogg
    flac
    libopus
    speex
    fontconfig
    freetype
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXfixes
    xorg.libXrender
    xorg.libXv
    xorg.libXxf86vm
    xorg.libxcb
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXtst
    gtk3
    gdk-pixbuf
    cairo
    pango
    glib
    dbus
    udev
    glew
    libjpeg_turbo
    libpng
    libtiff
    cups
    libxml2
    libxslt
    zlib
    bzip2
    xz
    zstd
    openssl
    curl
    ncurses
    libgcc
    libgphoto2
    sane-backends
    gsm
    libusb1
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    samba4
    opencl-headers
    ocl-icd
    libcap
    libva
    libdrm
    libinput
    libevdev
    wayland
    libxkbcommon
  ]);
  multiPkgs = pkgs: (with pkgs; [
    # 32-bit versions of critical libs
    mesa
    libglvnd
    vulkan-loader
    alsa-lib
    libpulseaudio
    fontconfig
    freetype
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXfixes
    xorg.libXrender
    xorg.libXv
    xorg.libXxf86vm
    xorg.libxcb
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXtst
    libjpeg_turbo
    libpng
    zlib
    bzip2
    libgcc
    libgphoto2
    glib
    gdk-pixbuf
    cairo
    pango
    gtk3
    dbus
    libxml2
    libxslt
    openssl
    cups
    libvorbis
    libogg
    OpenAL
    ncurses
    libcap
    libva
    libdrm
    ocl-icd
  ]);
  runScript = "bash";
}
```

Then:
```bash
# Enter the FHS environment
bfme2-env

# Now you're in a standard Linux filesystem — run Wine normally
wine ~/Downloads/FULL_SWITCHER.exe
```

**Honest assessment**: Even this list is probably incomplete. `steam-run` ships 515 packages and is maintained by the NixOS community specifically to handle this problem. The custom FHS approach is more "pure" but you'll likely hit missing library errors and have to keep adding packages. **Just use `steam-run`.**

### Option C: Lutris (GUI-Driven)

Lutris handles the Wine prefix and FHS issues automatically:

```nix
home.packages = with pkgs; [
  lutris
  wineWowPackages.staging
];
```

Lutris has a verified BFME2 installer script (DVD + Fan Patch + HD Mod) that automates the entire setup. However, it's a Flatpak/host-level wrapper and may need extra permissions for ISO mounting.

### What Actually Breaks Without FHS

| Tool | Why it fails on plain NixOS |
|---|---|
| `winetricks` | Calls `cabextract`, `p7zip`, `unrar`, etc. which must be in PATH at standard locations |
| BFME2 Patch Switcher | Python-based Windows installer; may shell out to Windows system calls that Wine translates to Linux paths |
| T3A:Online Launcher | .NET app that expects standard Windows paths inside the Wine prefix, which is fine, but its *installer* (.msi) may fail without FHS |
| Direct3D / DXVK setup | `winetricks d3dx9` needs to unpack DLLs — requires `cabextract` in PATH |

**Recommendation**: Use **Option A (`steam-run`)** for initial setup (installing the game, patches, and T3A), then you can launch the game directly with plain `wine` for day-to-day play since the game itself doesn't need FHS — only the installers do.

---

## 8. Troubleshooting

### Game crashes instantly on launch
- **Missing `options.ini`**: See Phase 3 above. This is the #1 cause.
- **Wrong Wine arch**: BFME2 is 32-bit. Your prefix must be `win32`.

### Auto-defeat after 3.5 minutes
- Install the 1.09 patch (or RotWK 2.02). The DRM is killing you.

### Game can't connect online / "Could not connect to server"
- Use T3A:Online launcher, not the original GameSpy
- Check firewall: UDP 16000 must be open if you're hosting
- If behind Tailscale, make sure the Tailscale interface allows UDP 16000

### LAN game not showing up
- Make sure all players are on the same VPN (Tailscale/Hamachi)
- The host must have UDP 16000 open
- Try using Direct IP: enter the host's Tailscale IP directly
- If LAN discovery fails, you can try adding the host IP manually

### Wine-specific issues
- Use `wineWowPackages.staging` — it has the best compatibility
- Some users report needing `winetricks d3dx9 d3dcompiler_47` for DirectX
- If the Patch Switcher crashes, try running with `WINEDEBUG=+loaddll wine ...`

### Performance issues
- BFME2 is capped at 30 FPS by design (game speed is tied to frame rate)
- If it's running too fast or too slow, check your monitor refresh rate
- You can try `WINE_FULLSCREEN_FSR=1` for upscaling on lower-end hardware

### RotWK won't detect BFME2
- Make sure both are installed in the same Wine prefix
- RotWK expects BFME2 to be at the standard English path — symlinks help (see Phase 2)

---

## 8. Complete NixOS Configuration Snippet

Here's everything you need added to your NixOS config:

```nix
# In your host configuration.nix (e.g., hosts/simon-pc/configuration.nix):

# Enable Tailscale for VPN gaming
services.tailscale.enable = true;

# Open BFME2 LAN port on Tailscale interface only
networking.firewall.interfaces.tailscale0 = {
  allowedUDPPorts = [ 16000 ];
};

# If you also want to host for T3A:Online (public internet):
# networking.firewall.allowedUDPPorts = [ 16000 ];
```

```nix
# In your home config (e.g., home/simon/common-gui.nix):
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wineWowPackages.staging
    winetricks
  ];
}
```

---

## 9. What Would a "Full Flake" Look Like?

A more ambitious approach would package the entire install as a Nix derivation or write an install script:

```nix
# packages/bfme2/default.nix — Conceptual
{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "bfme2-install";
  runtimeInputs = with pkgs; [ wineWowPackages.staging winetricks coreutils findutils gnused ];
  text = ''
    set -euo pipefail

    WINEPREFIX="''${WINEPREFIX:-$HOME/.local/share/bfme2/wine-prefix}"
    WINEARCH=win32

    echo "=== BFME2 Installer for NixOS ==="
    echo "Wine prefix: $WINEPREFIX"

    if [ ! -d "$WINEPREFIX" ]; then
      echo "Creating Wine prefix..."
      WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" wineboot --init
      WINEPREFIX="$WINEPREFIX" wineserver -w
    fi

    APPDATA="$WINEPREFIX/drive_c/users/$(whoami)/Application Data"
    OPTDIR="$APPDATA/My Battle for Middle-earth(tm) II Files"
    mkdir -p "$OPTDIR"

    if [ ! -f "$OPTDIR/options.ini" ]; then
      echo "Creating options.ini..."
      cat > "$OPTDIR/options.ini" << 'INIEOF'
    AudioLOD = High
    FlashTutorial = 0
    HasSeenLogoMovies = yes
    IdealStaticGameLOD = High
    Resolution = 1920 1080
    StaticGameLOD = High
    TimesInGame = 6
    INIEOF
    fi

    echo ""
    echo "Now mount your BFME2 ISO and run:"
    echo "  wine /path/to/AutoRun.exe"
    echo ""
    echo "After installation, download and run the 1.09 Patch Switcher:"
    echo "  wine ~/Downloads/FULL_SWITCHER.exe"
    echo ""
    echo "For multiplayer, see the guide at documentation/bfme2-nixos-guide.md"
  '';
}
```

A true Nix derivation that packages the game fully is **not practical** because:
- The game discs contain copyrighted assets that can't be distributed
- The patches are Windows .exe installers that need to run under Wine
- The game needs a persistent writable Wine prefix for saves/config

The best NixOS approach is therefore **helper scripts + system config**, not a full derivation.

---

## 10. Quick Reference: What to Download

| Item | URL |
|---|---|
| BFME2 ISO | https://t3aonline.net/download/ (community archive) |
| Patch Switcher 1.09 v3.0 | https://github.com/ValheruGR/BFME2/releases |
| T3A:Online Launcher | https://t3aonline.net/download/ |
| RotWK 2.02 Patch | https://www.gamereplays.org/riseofthewitchking/portals.php?show=page&name=unofficial-patch-202-download-page |
| HD Edition Mod | https://www.moddb.com/mods/battle-for-middle-earth-2-hd-edition |
| RotWK ISO | https://t3aonline.net/download/ (if you want the expansion) |
| Tailscale | https://tailscale.com/ (or `services.tailscale.enable = true` in NixOS) |

---

## 11. Feasibility Assessment

| Aspect | Status | Notes |
|---|---|---|
| **Single-player under Wine** | Fully working | Lutris has verified installers; 32-bit Wine prefix required |
| **Multiplayer (T3A:Online)** | Working | Launcher runs under Wine; community is active |
| **Multiplayer (LAN+Tailscale)** | Working | UDP 16000 over virtual LAN; tested pattern |
| **NixOS packaging** | Helper scripts + config | Full Nix derivation not practical (copyrighted assets); helper scripts are the right approach |
| **RotWK expansion** | Working | Use 2.02 v9.0.0+ for off-host delay fix |
| **Off-host delay** | Fixed in RotWK 2.02 v9.0.0+ | **NOT fixed in base BFME2** — only in RotWK |
| **Long-term viability** | Good | Active community (GameReplays.org, T3A:Online Discord); patches still being maintained (1.09 v3.0 released Jan 2024) |

**Bottom line: Fully feasible. The most annoying part is the initial Wine prefix setup + patch installation, but once done, the game runs well on NixOS. For multiplayer with friends, Tailscale+LAN is the path of least resistance.**