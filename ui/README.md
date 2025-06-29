# UI

## Why
UI scripts and scenes live here. They connect menu buttons and HUD nodes to game managers so the display always matches current gameplay.

## Responsibilities
- Render hands, boards, shops and the action log.
- Provide `MainMenu` and `LobbyMenu` for solo or online play.
- Show resources and the end-turn button through `StatsUI`.
- Support drag and drop via `CardButton` and open dialogs such as `MarketDialog`.
- `MarketDialog` propose un `SpinBox` pour miser et un bouton "Miser" qui envoie la mise.
- `BiomeShopUI` lists seasonal cards and hooks to `BiomeShop`.
- Spawn `HandUI` and `StatsUI` only for human players to avoid AI HUD clutter.
- Offer tutorial hints through `TutorialOverlay`.
- Use anchored containers so layouts scale with window size.
 - Scripts use tabs for indentation to match Godot defaults.

`StatsUI` spans the top, `BoardsPanel` holds one `BoardUI` per player in the middle and `HandUI` stays at the bottom. `HistoryUI` occupies the right edge. Signals like `hand_changed`, `board_changed` and `auction_open` keep every panel in sync. BoardUI also shows life, gold, essence and mana under each player's name. Each card preview uses the same `CardButton` layout so stats and costs stay consistent. `BiomeShopUI` hides after a purchase and the shop refills before the next season. CardButton also wraps effect descriptions to keep text inside the button. `CardButton.tscn` now embeds an `AnimationPlayer` for spawn and destroy cues. `CardButton` and `TerrainTile` display small textures from `assets/effects/` when available.
Players can click a unit then select a destination tile to move it. Dragging works too, forwarding the coordinates to `BoardManager.move_unit`.
`BoardUI` sets `mouse_filter` to `IGNORE` on inner labels so each cell's panel receives the click event.

## Public APIs
| File | Functions | Effect |
|------|-----------|-------|
| `tutorial_overlay.gd` | `show_tip(msg)`, `hide()` | Toggle tutorial popups. |
| `card_button.gd` | signal `dragged(card)` | Emits when dragging a card icon and shows season effect summaries. |
| Other scripts | *(none)* | Listen for events and refresh the HUD. |

When a card is dragged, `HandUI` forwards the signal to `GameManager.play_card`. Menus run at 1280×720 in windowed mode, then switch to fullscreen at 1920×1080 when a match begins. Full layout notes live in `details.md`.
