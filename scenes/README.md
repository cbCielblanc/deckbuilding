# Scenes

## Why
Scenes describe the node hierarchy for menus, gameplay and popups. They remain light and rely on scripts in sibling folders for logic.

## Responsibilities
- Provide entry points such as `MainMenu.tscn` and `LobbyMenu.tscn`.
- Host the main gameplay tree in `Main.tscn` with `GameManager` as a `Node2D` root so terrain and board visuals appear.
- Include UI fragments like `BoardsPanel.tscn`, `BoardUI.tscn`, `HandUI.tscn` and shop dialogs.
 - `StatsUI` sits at the top of the canvas with an **End** button, `BoardsPanel` centers the player boards with extra spacing and holds multiple `BoardUI` instances in the middle while
   `HandUI` anchors to the bottom so gameplay information is clearly separated.
- `TutorialOverlay.tscn` shows hints when running the tutorial.

## Flow

`MainMenu.tscn` loads first and lets the player choose solo, network or tutorial. Menus display in a 1280×720 window so the game launches in a compact mode. In multiplayer the `LobbyMenu.tscn` waits until enough peers join before moving to `Main.tscn`. When a match begins, the window switches to exclusive fullscreen at 1920×1080. During play the board and terrain are spawned under `GameManager`. Dialogs for the market and biome shop are instantiated only when opened, keeping the scene tree lean. `GameManager` spawns `BiomeShopDialog` at every season start so players can purchase biome cards before the first turn.

## Key Scenes
| Scene | Purpose |
|------|---------|
| `MainMenu.tscn` | Buttons to start solo or online mode with a background. |
| `LobbyMenu.tscn` | Connects peers and displays player list. |
| `Main.tscn` | Contains battle board, managers and a background. |
| `HistoryUI.tscn` | Panel showing the action log on the right side. |
| `MarketDialog.tscn` | Auction popup with a bid `SpinBox` and "Miser" button. |
| `BiomeShopDialog.tscn` | Popup showing seasonal cards at the start of each season. |
| `TerrainTile.tscn` | Visual tile with drop shadow, a transparent `Control` overlay and a `Label` that shows the biome name. Includes an `AnimationPlayer` for spawn and battle effects. |
| `CardButton.tscn` | Button used in `HandUI` to display cards. Now has an `AnimationPlayer` so GameManager can animate plays. |


Scenes rarely contain code beyond hooking up their child nodes. When adding a new scene, keep scripts minimal and delegate behaviour to a manager in `scripts/` or UI controller in `ui/` so the structure stays maintainable.
Both main scenes use a `TextureRect` named `Background` that loads `assets/ui/bg_main.png` to cover the screen.
### Notes
Temporary scene files (`*.tmp`) may appear during editing. They are ignored in git and can be safely removed.
