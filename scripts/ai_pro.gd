extends Player
class_name AIPro

func _ai_play() -> void:
	_prioritise()
	_attack_phase()
	SaveManager.save_run({"last_ai_turn": Time.get_unix_time_from_system()})
	end_turn()

# ------------------------------------------------------------- logique
func _prioritise() -> void:
        var sorted := hand.duplicate()
        sorted.sort_custom(Callable(self, "_cmp_atk"))   # ← 1 seul argument

        for c in sorted:
                var cost : int
                if c.card_type == constants.CardType.UNIT:
                        cost = 2
                elif c.card_type == constants.CardType.SPELL:
                        cost = 1
                else:
                        cost = 3

                if cost > mana:
                        continue

                get_parent().play_card(c, self)

func _cmp_atk(a, b) -> int:
	var atk_a : int = a.atk if a.atk != null else 0
	var atk_b : int = b.atk if b.atk != null else 0
	return atk_b - atk_a

# ------------------------------------------------------------- actions
func _cast(c : Card) -> void:
	var eff : Dictionary = c.effects.get(SeasonManager.current(), {})   # ← typé
	var tgt : Card = null
	if opponent().units.size() > 0:
		tgt = opponent().units[0]
	EffectProcessor.apply(eff, c, tgt)

func _summon(c : Card) -> void:
	c.owner = self
	units.append(c)

func _struct(c : Card) -> void:
	c.owner = self
	structures.append(c)

func _attack_phase() -> void:
	BattleManager.full_attack(self, opponent())
