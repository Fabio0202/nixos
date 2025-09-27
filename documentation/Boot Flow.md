
- Weil boot sachen ziemlich tief in system-settings zugreifen müssen, findest du module die beim boot gebraucht werden alle inin /hosts/modules

Der import von den modulen sieht meistens so aus

```mermaid
graph LR
A["flake.nix"] --> B["hosts/deinpc/configuration.nix"]
B --> C["hosts/configuration-common.nix"]
C --> D["hosts/modules/<beliebiges boot modul>.nix"]
```

Der boot flow sieht ungefähr so aus.

```mermaid
graph TD
A["Boot"] --> B["GRUB"]
B -->C["plymouth"]
C --> D["SDDM"]
D --> E["hyprland"]
```

- [[Grub]] 
	- Zuständig für die Liste am anfang sieht
	
- [[Plymouth]]
	- Zeigt die boot animation am anfang statt den hässlichen terminal einträgen

- [[SDDM]]
	- das was du siehst bevor du in hyprland reinbootest.
- [[Hyprland]]
	- jetzt bist du im system drin.