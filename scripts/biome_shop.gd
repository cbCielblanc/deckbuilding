extends Node
class_name BiomeShop
signal bought(p, card)

@export var biome : String = "Forest"
@export var size  : int    = 4
var stock : Array[Card] = []

func _ready(): _refill()

func _refill():
	var pool := CardDatabase.biome(biome).duplicate()
	pool.shuffle()
	stock = pool.slice(0, size)

func buy(p:Player, idx:int):
	if p.gold < 4 or p.essence < 2: return
	var c := stock[idx]
	p.gold    -= 4
	p.essence -= 2
	p.deck.add(c.copy())
	stock.remove_at(idx)
	emit_signal("bought", p, c)
	if stock.is_empty(): _refill()
