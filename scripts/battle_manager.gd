extends Node
# class_name BattleManager

# ------------------------------------------------------- lifecycle
static func destroy(c : Card) -> void:
	var o := c.owner
	if c in o.units:      o.units.erase(c)
	elif c in o.structures: o.structures.erase(c)
	EventBus.emit("card_destroyed", {"card": c})

# ------------------------------------------------------- combat helpers
static func unit_vs_unit(a:Card, d:Card) -> void:
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
		else:
			def.take_direct_dmg(u.atk)
		i += 1
