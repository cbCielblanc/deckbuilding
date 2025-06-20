extends Button
class_name CardButton

## Ce script est instancié par CardButton.tscn
## Il gère le drag-and-drop d’une carte depuis la main vers le plateau.

var card_data : Card

# Percentage of the screen width this button should occupy.
@export var size_ratio : float = 0.1

const CARD_TEXTURES := {
	   "Forest": preload("res://assets/cards/forest_card.png"),
	   "Desert": preload("res://assets/cards/desert_card.png"),
	   "Reef": preload("res://assets/cards/reef_card.png"),
	   "Swamp": preload("res://assets/cards/swamp_card.png"),
	   "Tundra": preload("res://assets/cards/tundra_card.png"),
	   "Volcano": preload("res://assets/cards/volcano_card.png"),
	   "Neutral": preload("res://assets/cards/neutral_structure.png")
}

signal dragged(card : Card)

func _ready() -> void:
		text = card_data.name
		icon = CARD_TEXTURES.get(card_data.biome, CARD_TEXTURES["Neutral"])
		expand_icon = true
		var width := get_viewport_rect().size.x * size_ratio
		custom_minimum_size = Vector2(width, width * 1.5)

func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("dragged", card_data)
