extends VBoxContainer
class_name BoardUI

@export var player_path : NodePath
@export var board_path  : NodePath
var player : Player
var board  : BoardManager

func _ready() -> void:
	player = get_node(player_path)
	board = get_node(board_path)
	EventBus.connect("event", Callable(self, "_on_event"))
	_refresh()

func _on_event(tag:String, _payload:Dictionary) -> void:
	if tag == "board_changed":
		_refresh()

# ----------------------------------------------------------------- refresh
func _refresh() -> void:
	# 1) vider proprement le VBoxContainer
	for child in get_children():
		remove_child(child)
		child.queue_free()
	# 2) afficher la grille
	if board and board.grids.has(player):
		for y in board.height:
			var row := HBoxContainer.new()
			for x in board.width:
				var lbl := Label.new()
				var c : Card = board.grids[player][x][y]
				lbl.text = c ? c.name : "-"
				row.add_child(lbl)
			add_child(row)

	# 3) afficher les structures
	if player.structures.size() > 0:
		var head := Label.new()
		head.text = "Structures:"
		add_child(head)
		for s in player.structures:
			var lbl := Label.new()
			lbl.text = "[S] %s  (%d PV)" % [s.name, s.hp]
			add_child(lbl)

