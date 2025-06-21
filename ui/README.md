# UI

## Why
User interface scripts and scenes live here. They connect nodes to game managers via signals so that the board, shop and menus always reflect current gameplay.

## Responsibilities
- Render a player's hand, battlefield and shops (`HandUI`, `BoardUI`, `BiomeShopUI`).
- Display resources such as life and gold (`StatsUI`).
- Provide menus for solo and network play (`MainMenu`, `LobbyMenu`).
- Support drag and drop of cards and show dialogs (`CardButton`, `MarketDialog`).
- `CardButton` sizes icons based on the window (`size_ratio` export) and
  sets `expand_icon` so large textures shrink to fit.
- Present tutorial hints through `TutorialOverlay`.
- UI scripts keep tab indentation so Godot formatting stays uniform. `BoardUI`=
  now uses tabs exclusively after removing stray spaces.=

During play, the HUD divides the screen into three bands: `StatsUI` spans the
top, `BoardUI` fills the middle, and `HandUI` anchors to the bottom. Each panel
uses anchors instead of hard-coded coordinates so the layout scales with the
window size.

`BoardUI` builds a `GridContainer` sized by `BoardManager.width` and
`BoardManager.height`. Each cell is a `Panel` with two centred labels: the
occupying card name (or a dash when empty) and a second line for stats. Units
display their `attack` and `hp` as "atk/hp" while structures show "HP: x". The
panels expand to fill the available width so the board appears as a neat grid.=

`HandUI`, `BoardUI`, `StatsUI`, `BiomeShopUI` and `MarketDialog` update text labels, spawn buttons and react to button presses. They do not expose functions; instead they listen for signals like `hand_changed`, `stats_changed` or `auction_open` to refresh their content. `LobbyMenu` manages the network lobby by connecting to `NetworkManager` signals. `MainMenu` transitions to the lobby or tutorial scenes and keeps the window in a 1280×720 launcher mode. When a game starts, both menus switch the display to exclusive fullscreen at 1920×1080.

## Public APIs
Only `TutorialOverlay` exposes calls so other nodes can show or hide tips when needed.

| File | Functions | Effect on game |
|------|-----------|----------------|
| `tutorial_overlay.gd` | `show_tip(msg)`, `hide()` | Display or remove an instructional popup. |
| `card_button.gd` | signal `dragged(card)` | Sends the card when the player drags its icon. |
| Other UI scripts | *(no public functions)* | They update visuals when notified via signals. |


Even without direct APIs, these scripts form the backbone of the player's experience. Any future additions to the HUD or dialogs should follow the same pattern: emit a signal from gameplay code, listen here, and update nodes in `ready` or signal callbacks.
