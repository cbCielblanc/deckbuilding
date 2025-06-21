extends HBoxContainer
class_name HandUI

@export var player_path : NodePath
var player : Player

func _ready() -> void:
	player = get_node(player_path)
	player.add_to_group("local_player")
	player.connect("hand_changed", Callable(self, "_refresh"))   # ← connection
	_refresh()

func _refresh(_p : Player = null) -> void:
	# Nettoyage
	for child in get_children():
		remove_child(child)
		child.queue_free()

	# Reconstruction de la main
	for c in player.hand:
		var btn := preload("res://scenes/CardButton.tscn").instantiate()
		btn.card_data = c
		btn.dragged.connect(_on_card_dragged.bind(c))
		add_child(btn)

func _on_card_dragged(card:Card) -> void:
	var gm := get_tree().get_root().get_node("Main")
	gm.play_card(card, player)
