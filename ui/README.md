# UI

## Why
User interface scripts and scenes live here. They connect nodes to game managers via signals so that the board, shop and menus always reflect current gameplay.

## Responsibilities
- Render a player's hand, battlefield and shops (`HandUI`, `BoardUI`, `BiomeShopUI`) and the action log (`HistoryUI`).
- `HandUI` and `StatsUI` are only instantiated for human players so AI opponents never create overlapping HUD elements.
- Display resources such as life and gold (`StatsUI`) and provide an **End** button to finish the turn.
- Provide menus for solo and network play (`MainMenu`, `LobbyMenu`).
- Support drag and drop of cards and show dialogs (`CardButton`, `MarketDialog`).
- `CardButton` sizes icons based on the window (`size_ratio` export) and
  uses its built‑in `icon` property to display the card artwork. A
  `VBoxContainer` inside the button stacks four labels beneath the icon:
  name, stats, mana cost and effect names. Hovering reveals the same
  details in a tooltip.
- Present tutorial hints through `TutorialOverlay`.
- UI scripts keep tab indentation so Godot formatting stays uniform. `BoardUI`
  now uses tabs exclusively after removing stray spaces.

During play, the HUD divides the screen into three bands: `StatsUI` spans the
top, `BoardsPanel` fills the middle and holds one `BoardUI` per player, and
`HandUI` anchors to the bottom. Each panel uses anchors instead of hard-coded
coordinates so the layout scales with the window size. `HistoryUI` occupies the
right quarter of the screen and lists recent events.

`BoardUI` builds a `GridContainer` sized by `BoardManager.width` and
`BoardManager.height`. A label with the player's name appears above the grid.
Each cell is a `Panel` with the card name followed by three lines: stats,
mana cost and a short list of effect names. Units display their `attack` and
`hp` as "atk/hp" while structures show "HP: x". The panels expand to fill
the available width so the board appears as a neat grid.

`HandUI` shows the same details for each card by using `CardButton`, so the
player always sees stats, cost and effects while choosing a card to play.

`HandUI` connects each `CardButton` to `GameManager.play_card` when dragged so cards are played instantly. `BoardUI`, `StatsUI`, `BiomeShopUI` and `MarketDialog` update text labels or buttons when notified via signals like `hand_changed`, `stats_changed` or `auction_open`. `LobbyMenu` manages the network lobby by connecting to `NetworkManager` signals. `MainMenu` transitions to the lobby or tutorial scenes and keeps the window in a 1280×720 launcher mode. When a game starts, both menus switch the display to exclusive fullscreen at 1920×1080.

## Public APIs
Only `TutorialOverlay` exposes calls so other nodes can show or hide tips when needed.

| File | Functions | Effect on game |
|------|-----------|----------------|
| `tutorial_overlay.gd` | `show_tip(msg)`, `hide()` | Display or remove an instructional popup. |
| `card_button.gd` | signal `dragged(card)` | Sends the card when the player drags its icon. |
| Other UI scripts | *(no public functions)* | They update visuals when notified via signals. |


Even without direct APIs, these scripts form the backbone of the player's experience. Any future additions to the HUD or dialogs should follow the same pattern: emit a signal from gameplay code, listen here, and update nodes in `ready` or signal callbacks.
