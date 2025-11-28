```mermaid
graph TD
  A["Linux Kernel"] --> B["Wayland"]
  A --> C["X11/Xserver"]

  B --> D["Hyprland (Wayland compositor)"]
  C --> E["Window Managers for X11 (e.g. i3, Openbox)"]

  D --> F["Apps running on Wayland"]
  E --> G["Apps running on X11"]
```

Ein Window Manager läuft _oben drauf_ auf dem [[xserver]]. Er bestimmt, **wie die Fenster aussehen und angeordnet sind** – z. B. ob sie kachelartig wie bei [[gnome]] oder frei verschiebbar sind. Der [[xserver]] zeichnet, der Window Manager organisiert.
https://www.youtube.com/watch?v=LAaul9OlxNc

- **Hyprland**

