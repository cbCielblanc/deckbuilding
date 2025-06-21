# UI Details

This document holds the extended layout notes that were trimmed from `README.md`.

### Layout
During play the HUD divides the screen into three bands: `StatsUI` at the top, `BoardsPanel` with one `BoardUI` per player in the middle, and `HandUI` anchored at the bottom. `HistoryUI` occupies the right quarter. Anchors replace hard-coded positions so everything scales with the window.

`BoardUI` builds a grid based on `BoardManager.width` and `height`. A label above the grid shows the player's name followed by life, gold, essence and mana. Each cell is a `Panel` listing the card name, stats and cost. Units display attack and hit points as "atk/hp" while structures show "HP: x".

`HandUI` relies on the same `CardButton` layout. Dragging a card connects to `GameManager.play_card`. Shops and dialogs update through signals such as `hand_changed`, `stats_changed` and `auction_open`. Menus start in a 1280×720 window and switch to 1920×1080 fullscreen when a match begins.
