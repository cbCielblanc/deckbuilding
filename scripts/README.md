# Scripts

## Why
Gameplay logic and autoloaded singletons live here. Keeping them together lets managers coordinate turns, AI and networking across scenes.

## Responsibilities
- Control turns and seasons via `GameManager`, `SeasonManager` and `BattleManager`.
- Manage card data, decks and board state.
- Provide AI routines and network RPCs through `NetworkManager`.
- Offer helpers like `Logger`, `SaveManager` and `EventBus`.
- Manage terrain visuals each season through `TerrainManager` and `TerrainTile`.

`GameManager.play_card` emits `hand_changed` so the UI refreshes and calls `BoardManager.remove_dead` after resolving effects. AI opponents call the same method so structures spawn without extra triggers. `BoardManager` rebuilds the grid and emits `board_changed` whenever units move. Tutorial steps use `TutorialManager.start()` and `on_action(tag)`.

## Key APIs
| Script | Functions |
|--------|-----------|
| `battle_manager.gd` | `destroy(card)`, `unit_vs_unit(a,d)`, `full_attack(att,def)` |
| `board_manager.gd` | `init_board(players)`, `place_card(p,card,x,y)`, `move_unit(...)`, `remove_dead()` |
| `game_manager.gd` | `play_card(card,p)`, `remote_play_card(id,owner)`, `remote_end_turn(owner)` |
| `network_manager.gd` | `rpc_play_card(id,owner)`, `rpc_end_turn(owner)` |
| `player.gd` | `draw(n)`, `start_turn()`, `end_turn()`, signal `board_changed(p)` |
| `season_manager.gd` | `reset()`, `current()`, `advance_segment()` |
| `effect_processor.gd` | `apply(effect, src, tgt)` |
| Helpers | `Logger.info(msg)`, `SaveManager.save_run(state)` |

Example: when a player uses a card, `GameManager.play_card` updates the board then `NetworkManager` forwards the RPC so peers stay in sync.
Market auctions rely on `MarketManager` which opens, bids and closes each round.
