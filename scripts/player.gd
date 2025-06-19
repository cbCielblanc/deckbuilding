extends Node
class_name Player

signal turn_end(p : Player)
signal defeated(p : Player)
signal hand_changed(p : Player)          # ← nouveau signal

@export var biome    : String = "Forest"
@export var is_human : bool   = true

var life        := constants.START_LIFE
var gold        := 10
var essence     := 0
var mana        := 3
var deck        := Deck.new()
var hand        : Array[Card] = []
var units       : Array[Card] = []
var structures  : Array[Card] = []
var tokens      : Dictionary  = {}

func _ready() -> void:
	add_child(deck)
	var starter : Array = CardDatabase.biome(biome)
	deck.add(starter[0].copy())
	deck.add(starter[1].copy())
	for i in 8:
		deck.add(CardDatabase.neutral()[0].copy())
	deck.shuffle()

func draw(n : int) -> void:
	hand += deck.draw_n(n)
	emit_signal("hand_changed", self)    # ← déclenche la mise à jour UI

func start_turn() -> void:
	mana = 3
	draw(5)
	if !is_human:
		_ai_play()

func end_turn() -> void:
	_cleanup_sleep()
	emit_signal("turn_end", self)

func opponent() -> Player:
	for p in get_parent().players:
		if p != self:
			return p
	return null

# -------------------------------------------------------------- helpers
func summon_token(name:String, atk:int, hp:int) -> void:
	var c := Card.new()
	c.name=name; c.atk=atk; c.hp=hp; c.max_hp=hp
	c.card_type=constants.CardType.UNIT; c.owner=self
	units.append(c)
	tokens[name] = tokens.get(name,0)+1

func consume_token(name:String, eff:String, val:int) -> void:
	if tokens.get(name,0) > 0:
		tokens[name] -= 1
		if eff == "team_atk":
			for u in units:
				u.atk += val

func take_direct_dmg(v:int) -> void:
	life -= v
	if life <= 0:
		emit_signal("defeated", self)

func _cleanup_sleep():
	for u in units:
		if u.status.sleep > 0:
			u.status.sleep -= 1

func _ai_play(): pass   # surchargé dans AIPro / AISwarm
