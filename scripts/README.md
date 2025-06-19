# Scripts

## Why
This folder collects all gameplay logic. Each GDScript stays loaded so managers can coordinate turns, AI and networking across scenes.

## Responsibilities
- Orchestrate players and seasons via `GameManager`, `SeasonManager` and `BattleManager`.
- Handle card data, decks and in-game effects.
- Provide AI behaviours and multiplayer RPCs through `NetworkManager`.
- Offer small helpers such as `Logger` and `SaveManager`.

## Public APIs
| File | Functions | Effect on game |
|------|-----------|----------------|
| `battle_manager.gd` | `destroy(card)`, `unit_vs_unit(a,d)`, `full_attack(att,def)` | Resolve combat and remove dead units. |
| `biome_shop.gd` | `buy(player, idx)` | Give a biome card to the player. |
| `board_manager.gd` | `init_board(players)`, `place_card(p,card,x,y)->bool`, `move_unit(p,x1,y1,x2,y2)->bool`, `remove_dead()` | Maintain board grid and unit lists. |
| `card.gd` | `copy()->Card`, `damage(v)` | Duplicate card or apply damage. |
| `card_database.gd` | `neutral()`, `biome(b)` | Provide card templates. |
| `deck.gd` | `shuffle()`, `draw_n(n)->Array`, `add(card)` | Manage player deck ordering. |
| `effect_processor.gd` | `apply(effect, src, tgt)` | Execute card effect dictionaries. |
| `event_bus.gd` | `emit(tag, payload={})` | Broadcast global events. |
| `game_manager.gd` | `remote_play_card(id,owner)`, `remote_end_turn(owner)` | Remote players interact via RPC. |
| `logger.gd` | `info(msg)`, `warn(msg)`, `error(msg)` | Simple logging facility. |
| `market_manager.gd` | `open()`, `bid(player,amt)`, `close()` | Handle shop bidding rounds. |
| `network_manager.gd` | `rpc_play_card(id,owner)`, `rpc_end_turn(owner)` | Forward network RPC to GameManager. |
| `player.gd` | `draw(n)`, `start_turn()`, `end_turn()`, `opponent()`, `summon_token(name,atk,hp)`, `consume_token(name,eff,val)`, `take_direct_dmg(v)` | Manage a player's resources and board presence. |
| `save_manager.gd` | `save_run(state)`, `load_run()->Dictionary` | Persist or load run state. |
| `season_manager.gd` | `reset()`, `current()`, `advance_segment()` | Cycle through seasons and emit signals. |
| `terrain_manager.gd` | `init(players)`, `season_update(season)` | Spawn and update terrain tiles. |
| `terrain_tile.gd` | `apply_season(season)` | Change tile visuals per season. |
| `tutorial_manager.gd` | `start()`, `on_action(tag)` | Drive tutorial step by step. |
| `ai_pro.gd`, `ai_swarm.gd` | *(no public API)* | Internal AI routines. |

## Example
```gdscript
var gm := GameManager.new()
add_child(gm)
SeasonManager.connect("season_start", Callable(self, "_on_season_start"))
```
