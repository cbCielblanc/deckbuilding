# Scripts

## Why
Gameplay logic and autoloaded singletons live here. Keeping them together lets managers coordinate turns, AI and networking across scenes.

## Responsibilities
- Control turns and seasons via `GameManager`, `SeasonManager` and `BattleManager`.
- Manage card data, decks and board state.
- Provide AI routines and network RPCs through `NetworkManager`.
- Offer helpers like `Logger`, `SaveManager` and `EventBus`.
- Manage terrain visuals each season through `TerrainManager` and `TerrainTile`.
- Spawn a `BiomeShop` at every season start so players can buy biome cards.
- `SeasonManager.current_biome()` maps the active season to a biome name.
- `BiomeShop` draws four cards from the current biome and any purchase adds the
  chosen card directly to the buyer's hand.

`GameManager.play_card` emits `hand_changed` so the UI refreshes and calls `BoardManager.remove_dead` after resolving effects. AI opponents call the same method so structures spawn without extra triggers. `Player.start_turn` now also grants one essence in addition to resetting mana. `BoardManager` rebuilds the grid and emits `board_changed` whenever units move. Tutorial steps use `TutorialManager.start()` and `on_action(tag)`.

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
| `constants.gd` | `describe_effect(effect)` |
| Helpers | `Logger.info(msg)`, `SaveManager.save_run(state)` |

Example: when a player uses a card, `GameManager.play_card` updates the board then `NetworkManager` forwards the RPC so peers stay in sync.
Market auctions rely on `MarketManager` which opens, bids and closes each round.
`_on_season_start` instantiates `BiomeShopDialog` with the new shop, then closes
it once a card is purchased and refills the stock.
