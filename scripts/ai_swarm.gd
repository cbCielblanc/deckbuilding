extends AIPro
class_name AISwarm

# ----------------------------------------------------------------- comparateur
## Priorité extrême aux cartes dont l’effet d’été est "burn" ou "poison",
## sinon tri décroissant par ATK.
func _cmp_atk(a, b) -> int:
	var score_a : int = 0
	var score_b : int = 0

	# ---- carte A -----------------------------------------------------
	if a.effects.has("summer") and a.effects.summer.action in ["burn", "poison"]:
		score_a = 100
	elif a.atk != null:
		score_a = a.atk

	# ---- carte B -----------------------------------------------------
	if b.effects.has("summer") and b.effects.summer.action in ["burn", "poison"]:
		score_b = 100
	elif b.atk != null:
		score_b = b.atk

	# Retour décroissant
	return score_b - score_a
