# Deck-Builder Roguelike

## Why
Seasonal deck-builder built with Godot 4.4.1. Cards interact with dynamic biomes and an in-game economy while online play and AI opponents keep matches fresh.

## Responsibilities
This is the Godot project root. Key folders:
- `scripts/` gameplay managers and logic
- `ui/` UI nodes and signals
- `scenes/` menus and main game scenes
- `data/` JSON card definitions
- `assets/` textures and icons
- `docs/` architecture notes

### Repository notes
- Temporary `.tmp` scene files are git-ignored.
### Running
1. Install Godot 4.4.1.
2. Run `godot4 .` or open `project.godot` in the editor. `MainMenu.tscn` starts by default.

## Key APIs
| File/Scene | Purpose |
|------------|---------|
| `scenes/MainMenu.tscn` | entry menu for solo and network play |
| `scripts/game_manager.gd` | manages turns and card effects |
| `scripts/season_manager.gd` | cycles seasons and updates terrain |
| `scripts/network_manager.gd` | sets up the lobby and forwards RPCs |

## Examples
- `godot4 .` – launch the game.
- Select **Solo** to face an AI match.
- Choose **Network** to host or join a lobby.
