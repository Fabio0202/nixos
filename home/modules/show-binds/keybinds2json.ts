// nix2json.ts
// Run with: deno run --allow-read --allow-write nix2json.ts keybindings.nix keybinds.json

const [nixPath, jsonPath] = Deno.args;
if (!nixPath || !jsonPath) {
  console.error(
    "Usage: deno run --allow-read --allow-write nix2json.ts <input.nix> <output.json>",
  );
  Deno.exit(1);
}

const text = await Deno.readTextFile(nixPath);
const lines = text.split("\n");

const binds: Array<Record<string, string>> = [];

// Hyprland dispatchers we care about
const DISPATCHERS = [
  "exec",
  "workspace",
  "movewindow",
  "resizeactive",
  "movefocus",
  "movetoworkspace",
  "movetoworkspacesilent",
  "fullscreen",
  "killactive",
  "togglespecialworkspace",
  "togglefloating",
  "switchxkblayout",
  "exit",
  "pin",
  "hyprexpo:expo",
];

for (const line of lines) {
  // Only match lines with "## Category | Description"
  const match = line.match(/"([^"]+)"\s*##\s*([^|]+)\s*\|\s*(.+)/);
  if (!match) continue; // Skip lines without the comment

  let [_, bindStr, category, description] = match;

  // Replace ${mainMod} with SUPER
  bindStr = bindStr.replace(/\$\{mainMod\}/g, "SUPER");

  const parts = bindStr.split(",").map((p) => p.trim());

  // Find dispatcher index
  const dispatcherIndex = parts.findIndex((p) =>
    DISPATCHERS.some((d) => p.startsWith(d)),
  );

  if (dispatcherIndex === -1) continue;

  // Keys = everything before dispatcher
  const keys = parts.slice(0, dispatcherIndex).join(" ").trim();

  // Command = everything from dispatcher onward
  const command = parts.slice(dispatcherIndex).join(" ").trim();

  binds.push({
    keys,
    command,
    category: category.trim(),
    description: description.trim(),
  });
}

await Deno.writeTextFile(jsonPath, JSON.stringify(binds, null, 2));
console.log(`✅ Parsed ${binds.length} binds → ${jsonPath}`);
