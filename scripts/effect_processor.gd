extends Node
# class_name EffectProcessor

func apply(e : Dictionary, src : Card, tgt = null) -> void:
	var a = e.get("action", "")
	match a:
		"atk":           tgt.atk += e.value
		"hp":            tgt.hp  = min(tgt.max_hp, tgt.hp + e.value)
		"team_atk":      for u in src.owner.units: u.atk += e.value
		"burn":          tgt.status.burn   += e.value
		"poison":        tgt.status.poison += e.value
		"draw":          src.owner.draw(e.value)
		"mana":          src.owner.mana += e.value
		"gain_gold":     src.owner.gold += e.value
		"charge":        src.charge += e.value
		"blast":
			if tgt: tgt.damage(e.value * src.charge)
			src.charge = 0
		"reset_charge":  src.charge = 0
		"skip_segment":  SeasonManager.advance_segment()
		"extend_season": SeasonManager.segment = max(0, SeasonManager.segment - 1)
		"root":          tgt.status.rooted = true
		"camouflage":    src.status.camouflage = true
		"sleep":         src.status.sleep = 1
		"freeze_unit":   tgt.status.frozen = 1
		"enemy_atk_mod": for u in src.owner.opponent().units: u.atk += e.value
		"create_token":  src.owner.summon_token(e.token, e.atk, e.hp)
		"consume_token": src.owner.consume_token(e.token, e.effect, e.value)
		"duplicate_phantom":
			var d := src.copy(); d.atk = 0; d.hp = 1; d.owner = src.owner
			src.owner.units.append(d)
		"transform":
			var rep : Card = CardDatabase.neutral().filter(func(c): return c.cid == e.new_id)[0].copy()
			var idx := src.owner.structures.find(src)
			if idx != -1: src.owner.structures[idx] = rep
		"penalty_draw":  src.owner.draw(e.value)          # value négatif
		_:
			Logger.warn("Unknown effect: %s" % a)
