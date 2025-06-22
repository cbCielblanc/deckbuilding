extends Node
# class_name BattleManager

# ------------------------------------------------------- lifecycle
static func destroy(c : Card) -> void:
	var o := c.owner
	if c in o.units:      o.units.erase(c)
	elif c in o.structures: o.structures.erase(c)
	EventBus.emit("card_destroyed", {"card": c})
	var tile := _tile_for(c)
	if tile:
		tile.play_destroy()

# ------------------------------------------------------- combat helpers
static func unit_vs_unit(a:Card, d:Card) -> void:
	_play_attack(a, d)
	d.damage(a.atk)
	if d.hp > 0:
		a.damage(d.atk)

static func full_attack(att:Player, def:Player) -> void:
	var i := 0
	while i < att.units.size():
		var u := att.units[i]
		if u.status.sleep > 0 or u.status.frozen > 0:
			i += 1; continue
		if def.units.size() > 0:
			var v := def.units[0]
			unit_vs_unit(u, v)
			EventBus.emit("history", {"msg": "%s attaque %s" % [u.name, v.name]})
		else:
			def.take_direct_dmg(u.atk)
			EventBus.emit("history", {"msg": "%s attaque %s directement" % [u.name, def.name]})
		i += 1

static func _play_attack(a:Card, d:Card) -> void:
	var ta := _tile_for(a)
	if ta:
		ta.play_attack()
	var td := _tile_for(d)
	if td:
		td.play_attack()

static func _gm() -> GameManager:
	return (Engine.get_main_loop() as SceneTree).root.get_node("Main")

static func _tile_for(c:Card) -> TerrainTile:
	var info := _gm().board.find_card(c)
	if info.has("player"):
		return _gm().terrain.tiles[info["player"]][info["x"]][info["y"]]
	return null
