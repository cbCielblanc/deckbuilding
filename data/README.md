# Data

## Why
This folder stores JSON files that describe all cards and other content. The game loads them on startup so designers can tweak values without touching code.

## Responsibilities
- Maintain `card_data.json` containing stats, costs and seasonal effects.
- Allow new biomes or card types to be added through simple JSON entries.
- Provide an import path for future editor or mod tools.

## Key Schema
`card_data.json` has two root dictionaries:
- `neutral_structures`: basic structures always present in the market.
- `biome_cards`: a set of lists indexed by biome name.
Each card entry includes fields like `id`, `name`, `type`, `atk`, `hp` and a map of `effects` that the `EffectProcessor` can understand.

When the file grows large, keep cards grouped by biome and sorted alphabetically to avoid merge conflicts. Non designers should refrain from hand editing values during playtesting; use the editor or a dedicated script to modify cards.


Future expansions may include creature animations or localisation strings which would live beside the card file. Use similar schema conventions so `CardDatabase` can load them reliably.

Card lists here are version controlled so changes can be reviewed. When balancing seasons, submit small focused edits so playtesters can track which tweaks affect difficulty.
