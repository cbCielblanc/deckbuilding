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

                # tooltip avec coût et statistiques
                var cost := 3
                match card_data.card_type:
                        constants.CardType.UNIT: cost = 2
                        constants.CardType.SPELL: cost = 1

                var stat_text := ""
                if card_data.card_type == constants.CardType.UNIT:
                        stat_text = "%d/%d" % [card_data.atk, card_data.hp]
                elif card_data.card_type == constants.CardType.STRUCTURE:
                        stat_text = "HP: %d" % card_data.hp

                var effect_str := ""
                for key in card_data.effects.keys():
                        effect_str += "%s: %s\n" % [key, card_data.effects[key].to_string()]

                tooltip_text = "Coût: %d\nStats: %s\n%s" % [cost, stat_text, effect_str]

                pressed.connect(_on_pressed)

func _gui_input(event : InputEvent) -> void:
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
                emit_signal("dragged", card_data)

func _on_pressed() -> void:
        emit_signal("dragged", card_data)
