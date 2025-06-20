# Scripts

## Why
This folder collects all gameplay logic. Each GDScript stays loaded so managers can coordinate turns, AI and networking across scenes.

## Responsibilities
- Orchestrate players and seasons via `GameManager`, `SeasonManager` and `BattleManager`.
- Handle card data, decks and in-game effects.
- Provide AI behaviours and multiplayer RPCs through `NetworkManager`.
- Offer small helpers such as `Logger` and `SaveManager`.
- Spawn `BoardUI` and `HandUI` when a match starts.
- Use tabs for indentation so Godot formatting stays consistent.

## Public APIs
| File | Functions | Effect on game |
|------|-----------|----------------|
| `battle_manager.gd` | `destroy(card)->void`, `unit_vs_unit(a,d)->void`, `full_attack(att,def)->void` | Resolve combat and remove dead units. |
| `biome_shop.gd` | `buy(player, idx)->void` | Give a biome card to the player. |
| `board_manager.gd` | `init_board(players)->void`, `place_card(p,card,x,y)->bool`, `move_unit(p,x1,y1,x2,y2)->bool`, `remove_dead()->void` | Maintain board grid and emit `board_changed` on updates. |
| `card.gd` | `copy()->Card`, `damage(v)->void` | Duplicate card or apply damage. |
| `card_database.gd` | `neutral()->Array`, `biome(b)->Array` | Provide card templates. |
| `deck.gd` | `shuffle()->void`, `draw_n(n)->Array`, `add(card)->void` | Manage player deck ordering. |
| `effect_processor.gd` | `apply(effect, src, tgt)->void` | Execute card effect dictionaries. |
| `event_bus.gd` | `emit(tag, payload={})->void` | Broadcast global events. |
| `game_manager.gd` | `remote_play_card(id,owner)->void`, `remote_end_turn(owner)->void` | Remote players interact via RPC. |
| `logger.gd` | `info(msg)->void`, `warn(msg)->void`, `error(msg)->void` | Simple logging facility. |
| `market_manager.gd` | `open()->void`, `bid(player,amt)->void`, `close()->void` | Handle shop bidding rounds. |
| `network_manager.gd` | `rpc_play_card(id,owner)->void`, `rpc_end_turn(owner)->void` | Forward network RPC to GameManager. |
| `player.gd` | `draw(n)->void`, `start_turn()->void`, `end_turn()->void`, `opponent()->Player`, `summon_token(name,atk,hp)->void`, `consume_token(name,eff,val)->void`, `take_direct_dmg(v)->void`, signal `board_changed(p)` | Manage a player's resources and board presence. |
| `save_manager.gd` | `save_run(state)->void`, `load_run()->Dictionary` | Persist or load run state. |
| `season_manager.gd` | `reset()->void`, `current()->String`, `advance_segment()->void` | Cycle through seasons and emit signals. |
| `terrain_manager.gd` | `init(players)->void`, `season_update(season)->void` | Spawn and update terrain tiles. |
| `terrain_tile.gd` | `set_biome(b)`, `apply_season(season)`, `set_color(color)`, `highlight(on)` | Uses a hidden `Control` child to detect hover; loads biome textures and tints tiles per season. |
| `tutorial_manager.gd` | `start()->void`, `on_action(tag)->void` | Drive tutorial step by step. |
| `ai_pro.gd`, `ai_swarm.gd` | *(no public API)* | Internal AI routines. |

