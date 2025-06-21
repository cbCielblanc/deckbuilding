# Scripts

## Why
This folder collects all gameplay logic. Each GDScript stays loaded so managers can coordinate turns, AI and networking across scenes.

## Responsibilities
- Orchestrate players and seasons via `GameManager`, `SeasonManager` and `BattleManager`.
- Handle card data, decks and in-game effects.
- Provide AI behaviours and multiplayer RPCs through `NetworkManager`.
- Offer small helpers such as `Logger` and `SaveManager`.
- Spawn `BoardUI` for every player but only create `StatsUI` and `HandUI` for human participants so AI hands never overlap in the HUD.
- All scripts use tab indentation; `board_manager.gd` and `terrain_manager.gd` were cleaned up to match.
- `GameManager.play_card` now emits `hand_changed` so the UI refreshes instantly and calls `BoardManager.remove_dead` after resolving effects.
- AI routines call `GameManager.play_card` directly so structures appear on every board without extra triggers.

## Public APIs
| File | Functions | Effect on game |
|------|-----------|----------------|
| `battle_manager.gd` | `destroy(card)->void`, `unit_vs_unit(a,d)->void`, `full_attack(att,def)->void` | Resolve combat and remove dead units. |
| `biome_shop.gd` | `buy(player, idx)->void` | Give a biome card to the player. |
| `board_manager.gd` | `init_board(players)->void`, `place_card(p,card,x,y)->bool`, `move_unit(p,x1,y1,x2,y2)->bool`, `remove_dead()->void` | Clear previous grids then rebuild and emit `board_changed` when slots update. |
| `card.gd` | `copy()->Card`, `damage(v)->void` | Duplicate card or apply damage. |
| `card_database.gd` | `neutral()->Array`, `biome(b)->Array` | Provide card templates. |
| `deck.gd` | `shuffle()->void`, `draw_n(n)->Array`, `add(card)->void` | Manage player deck ordering. |
| `effect_processor.gd` | `apply(effect, src, tgt)->void` | Execute card effect dictionaries. |
| `event_bus.gd` | `emit(tag, payload={})->void` | Broadcast global events. |
| `game_manager.gd` | `play_card(card,p)->void`, `remote_play_card(id,owner)->void`, `remote_end_turn(owner)->void` | Handle card use locally and for network peers. |
| `logger.gd` | `info(msg)->void`, `warn(msg)->void`, `error(msg)->void` | Simple logging facility. |
| `market_manager.gd` | `open()->void`, `bid(player,amt)->void`, `close()->void` | Handle shop bidding rounds. |
| `network_manager.gd` | `rpc_play_card(id,owner)->void`, `rpc_end_turn(owner)->void` | Forward network RPC to GameManager. |
| `player.gd` | `draw(n)->void`, `start_turn()->void`, `end_turn()->void`, `opponent()->Player`, `summon_token(name,atk,hp)->void`, `consume_token(name,eff,val)->void`, `take_direct_dmg(v)->void`, signal `board_changed(p)` | Manage a player's resources and board presence. |
| `save_manager.gd` | `save_run(state)->void`, `load_run()->Dictionary` | Persist or load run state. |
| `season_manager.gd` | `reset()->void`, `current()->String`, `advance_segment()->void` | Cycle through seasons and emit signals. |
| `terrain_manager.gd` | `init(players)->void`, `season_update(season)->void`, `groups_for_biome(b)->Array` | Recreate terrain visuals, removing old nodes, and expose groups per biome. |
| `terrain_tile.gd` | `set_biome(b)`, `apply_season(season)`, `set_color(color)`, `highlight(on)` | Each tile now includes a `Label` showing its biome and still uses a hidden `Control` for hover detection. |
| `tutorial_manager.gd` | `start()->void`, `on_action(tag)->void` | Drive tutorial step by step. |
| `ai_pro.gd`, `ai_swarm.gd` | *(no public API)* | Internal AI routines. |

