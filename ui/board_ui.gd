extends VBoxContainer
class_name BoardUI

@export var player_path : NodePath
var player : Player

func _ready() -> void:
	player = get_node(player_path)
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
