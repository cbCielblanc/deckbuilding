# Assets

## Why
All artwork and future audio are stored here. Godot imports files automatically so keeping them organised avoids bloating the repository with unused resources.

## Responsibilities
- Hold card illustrations in `cards/`.
- Keep UI icons like gold, mana or status effects in `ui/`.
- Record licences for any third party art or sound.

## Usage Notes
Use PNGs at power-of-two sizes so textures scale well. When adding new icons, create both the image and its `.import` file by dropping it into the Godot editor. If the asset comes from an external artist, document the licence and source in this README or a text file next to the asset.

## Key Files
| Folder | Content |
|-------|---------|
| `cards/` | frames such as `forest_card.png` and `neutral_structure.png` |
| `ui/` | icons including `gold.png`, `mana.png`, `burn.png` |


Large sprite sheets or sounds should live in a subfolder and be referenced by a scene so they are loaded only when necessary. Keeping this folder clean helps reduce build size and keeps git history manageable.

When removing outdated art, also delete the `.import` metadata to prevent orphan entries inside `project.godot`. Keep an eye on repository size; using texture compression in the import settings helps maintain a small footprint during version control.
