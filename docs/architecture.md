# Architecture

This project uses a set of Godot singletons to coordinate gameplay. `GameManager` sits at the center and drives turns, drawing from `Deck` objects and applying effects through `EffectProcessor`. It invokes `BattleManager` when units clash and notifies `BoardManager` so the board refreshes.

`SeasonManager` and `TerrainManager` work together to change the biome each turn. They rebuild tiles and adjust visuals so that cards react to the environment. `GameManager._apply_season_effects` runs at every season start to trigger passive abilities on units and structures. The `MarketManager` and `BiomeShop` open temporary dialogs allowing players to spend gold between battles. When the auction closes they send results back through `EventBus` signals.
`SeasonManager.current_biome()` looks up a biome for each season so the `BiomeShop` knows which card pool to draw from.

`NetworkManager` mirrors actions to connected peers using reliable UDP (ENet). Every UI script listens for changes via signals: `BoardUI` tracks the grid, `StatsUI` shows resources and `HandUI` handles drag-and-drop. These panels live under scenes described in `scenes/README.md`.

Saving and loading runs happens through `SaveManager`. Small utilities like `Logger` keep output consistent across the command line and editor. The architecture keeps scenes lightweight so most logic lives in scripts, making new features easier to test.

The diagram below shows the high level flow:

```
Main.tscn -> GameManager -> {BoardManager, SeasonManager, BattleManager}
                                 ↳ NetworkManager ↔ peers
                                 ↳ MarketManager ↔ UI dialogs
```
