extends VBoxContainer
class_name BoardUI

@export var player_path : NodePath
@export var board_path  : NodePath
var player : Player
var board  : BoardManager

func _ready() -> void:
	player = get_node(player_path)
	board  = get_node(board_path)
	board.connect("board_changed", Callable(self, "_on_board_changed"))
	_refresh()

func _on_board_changed(p : Player) -> void:
	if p == player:
		_refresh()

# ----------------------------------------------------------------- refresh
func _refresh() -> void:
	# 1) vider proprement le VBoxContainer
	for child in get_children():
		remove_child(child)
		child.queue_free()

	# 2) afficher les unités
	for u in player.units:
		var lbl := Label.new()
		lbl.text = "%s  (%d/%d)" % [u.name, u.atk, u.hp]
		add_child(lbl)

	# 3) afficher les structures
		for s in player.structures:
		var lbl := Label.new()
		lbl.text = "[S] %s  (%d PV)" % [s.name, s.hp]
		add_child(lbl)
