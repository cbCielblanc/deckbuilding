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
       if player:
               player.connect("board_changed", Callable(self, "_refresh"))
        _refresh()

func _on_event(tag:String, _payload:Dictionary) -> void:
	if tag == "board_changed":
		_refresh()

# ----------------------------------------------------------------- refresh
func _refresh() -> void:
	# 1) nettoyer le container
	for child in get_children():
		remove_child(child)
		child.queue_free()

	# Nom du joueur
	var head := Label.new()
	head.text = player.name
	head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(head)

	# 2) grille de jeu
	if board and board.grids.has(player):
		var grid := GridContainer.new()
		grid.columns = board.width
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
		grid.custom_minimum_size = Vector2(0, 200)
		for y in board.height:
			for x in board.width:
				var cell := Panel.new()
				cell.custom_minimum_size = Vector2(160, 80)
				cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				cell.size_flags_vertical = Control.SIZE_EXPAND_FILL

				var box := VBoxContainer.new()
				box.anchor_left = 0.0
				box.anchor_top = 0.0
				box.anchor_right = 1.0
				box.anchor_bottom = 1.0

				var c : Card = board.grids[player][x][y]

				var lbl_name := Label.new()
				lbl_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				lbl_name.text = c.name if c else "-"
				box.add_child(lbl_name)

				var lbl_stats := Label.new()
				lbl_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				if c:
					if c.card_type == constants.CardType.UNIT:
						lbl_stats.text = "%d/%d" % [c.atk, c.hp]
					elif c.card_type == constants.CardType.STRUCTURE:
						lbl_stats.text = "HP: %d" % c.hp
					else:
						lbl_stats.text = ""
				else:
					lbl_stats.text = ""
				box.add_child(lbl_stats)
				var lbl_cost := Label.new()
				lbl_cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				if c:
					var cost := 0
					match c.card_type:
						constants.CardType.UNIT:
							cost = 2
						constants.CardType.SPELL:
							cost = 1
						_:
							cost = 3
					lbl_cost.text = "Cost: %d" % cost
				else:
					lbl_cost.text = ""
				box.add_child(lbl_cost)

				var lbl_eff := Label.new()
				lbl_eff.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				if c:
					var actions : Array[String] = []
					for key in c.effects.keys():
						var eff : Dictionary = c.effects[key]
						actions.append(eff.get("action", ""))
					lbl_eff.text = "Eff: %s" % ", ".join(actions)
				else:
					lbl_eff.text = ""
				box.add_child(lbl_eff)

				cell.add_child(box)
				grid.add_child(cell)
		add_child(grid)

	# 3) afficher les structures
		if player.structures.size() > 0:
				var head_struct := Label.new()
				head_struct.text = "Structures:"
				add_child(head_struct)
		for s in player.structures:
			var lbl := Label.new()
			lbl.text = "[S] %s  (%d PV)" % [s.name, s.hp]
			add_child(lbl)
