# Scenes

## Why
Scenes describe the node hierarchy for menus, gameplay and popups. They remain light and rely on scripts in sibling folders for logic.

## Responsibilities
- Provide entry points such as `MainMenu.tscn` and `LobbyMenu.tscn`.
- Host the main gameplay tree in `Main.tscn` with `GameManager` as root.
- Include UI fragments like `BoardUI.tscn`, `HandUI.tscn` and shop dialogs.
- Supply tutorial overlays that appear during the first run.

## Flow
`MainMenu.tscn` loads first and lets the player choose solo, network or tutorial. In multiplayer the `LobbyMenu.tscn` waits until enough peers join before moving to `Main.tscn`. During a match the board and terrain are spawned under `GameManager`. Dialogs for the market and biome shop are instantiated only when opened, keeping the scene tree lean.

## Key Scenes
| Scene | Purpose |
|------|---------|
| `MainMenu.tscn` | Buttons to start solo or online mode. |
| `LobbyMenu.tscn` | Connects peers and displays player list. |
| `Main.tscn` | Contains battle board and managers. |
| `MarketDialog.tscn` | Popup for the neutral auction house. |


Scenes rarely contain code beyond hooking up their child nodes. When adding a new scene, keep scripts minimal and delegate behaviour to a manager in `scripts/` or UI controller in `ui/` so the structure stays maintainable.
