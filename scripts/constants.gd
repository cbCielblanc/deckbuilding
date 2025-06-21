extends Node
# class_name constants

enum Season {SPRING, SUMMER, AUTUMN, WINTER}
enum CardType {UNIT, SPELL, STRUCTURE}

const SEASON_NAMES := ["spring", "summer", "autumn", "winter"]
const START_LIFE   := 20

# French labels for seasons so UI can display readable effect summaries.
const SEASON_LABELS := {
	   "spring": "Printemps",
	   "summer": "Été",
	   "autumn": "Automne",
	   "winter": "Hiver",
}

# Convert a raw effect dictionary into a short human description.
static func describe_effect(e:Dictionary) -> String:
	var a : Variant = e.get("action", "")
	var v : Variant = e.get("value", 0)
	match a:
		"atk":           return "ATK %+d" % v
		"hp":            return "PV %+d" % v
		"team_atk":      return "ATK équipe %+d" % v
		"burn":          return "Brûlure %d" % v
		"poison":        return "Poison %d" % v
		"draw":          return "Pioche %d" % v
		"mana":          return "Mana %+d" % v
		"gain_gold":     return "Or %+d" % v
		"charge":        return "Charge %+d" % v
		"blast":         return "Explosion %d×charge" % v
		"reset_charge":  return "Réinitialise la charge"
		"skip_segment":  return "Avance la saison"
		"extend_season": return "Prolonge la saison"
		"root":          return "Enracine la cible"
		"camouflage":    return "Camouflage"
		"sleep":         return "Endort la cible"
		"freeze_unit":   return "Gèle la cible"
		"enemy_atk_mod": return "ATK ennemie %+d" % v
		"create_token":  return "Crée jeton %s" % e.get("token", "")
		"consume_token": return "Consomme %s" % e.get("token", "")
		"duplicate_phantom": return "Double fantôme"
		"transform":     return "Transforme en %s" % e.get("new_id", "")
		"penalty_draw":  return "Défausse %d" % (-v)
		_: return a
