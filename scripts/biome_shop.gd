extends Node
class_name BiomeShop
signal bought(p, card)

@export var biome : String = "Forest"
@export var size  : int    = 4
var stock : Array[Card] = []

func _ready(): _refill()

func _refill():
	var pool : Array[Card] = CardDatabase.biome(biome).duplicate() as Array[Card]
	pool.shuffle()
	stock = pool.slice(0, size) as Array[Card]

func buy(p:Player, idx:int):
	if p.gold < 4 or p.essence < 2:
		return
	var c := stock[idx]
	p.gold    -= 4
	p.essence -= 2
	p.emit_stats()
	var copy := c.copy()
	p.hand.append(copy)
	p.emit_signal("hand_changed", p)
	stock.remove_at(idx)
	emit_signal("bought", p, copy)
	if stock.is_empty():
		_refill()
