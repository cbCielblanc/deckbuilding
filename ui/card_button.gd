extends Button
class_name CardButton

## Ce script est instancié par CardButton.tscn
## Il gère le drag-and-drop d’une carte depuis la main vers le plateau.

var card_data : Card

signal dragged(card : Card)

func _ready() -> void:
	text = card_data.name

func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		emit_signal("dragged", card_data)
