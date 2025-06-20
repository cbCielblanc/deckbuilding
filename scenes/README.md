# Scenes

## Why
Scenes describe the node hierarchy for menus, gameplay and popups. They remain light and rely on scripts in sibling folders for logic.

## Responsibilities
- Provide entry points such as `MainMenu.tscn` and `LobbyMenu.tscn`.
- Host the main gameplay tree in `Main.tscn` with `GameManager` as root.
- Include UI fragments like `BoardUI.tscn`, `HandUI.tscn` and shop dialogs.
- Supply tutorial overlays that appear during the first run.

## Flow

`MainMenu.tscn` loads first and lets the player choose solo, network or tutorial. Menus display in a 1280×720 window so the game launches in a compact mode. In multiplayer the `LobbyMenu.tscn` waits until enough peers join before moving to `Main.tscn`. When a match begins, the window switches to exclusive fullscreen at 1920×1080. These size changes are disabled inside the editor to avoid "Embedded window" errors. During play the board and terrain are spawned under `GameManager`. Dialogs for the market and biome shop are instantiated only when opened, keeping the scene tree lean.

## Key Scenes
| Scene | Purpose |
|------|---------|
| `MainMenu.tscn` | Buttons to start solo or online mode with a background. |
| `LobbyMenu.tscn` | Connects peers and displays player list. |
| `Main.tscn` | Contains battle board, managers and a background. |
| `MarketDialog.tscn` | Popup for the neutral auction house. |
| `TerrainTile.tscn` | Visual tile scene with drop shadow used for each grid slot. |


Scenes rarely contain code beyond hooking up their child nodes. When adding a new scene, keep scripts minimal and delegate behaviour to a manager in `scripts/` or UI controller in `ui/` so the structure stays maintainable.
Both main scenes use a `TextureRect` named `Background` that loads `assets/ui/bg_main.png` to cover the screen.
