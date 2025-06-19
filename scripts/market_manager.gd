extends Node
class_name MarketManager
signal auction_open(card)
signal auction_close(card, winner)

var pool  : Array[Card] = []
var bids  : Dictionary  = {}
var current : Card

func _ready():
	pool.clear()
	pool.append_array(CardDatabase.neutral() as Array)
	pool.shuffle()

func open():
	if pool.is_empty(): return
	current = pool.pop_back()
	bids.clear()
	emit_signal("auction_open", current)

func bid(p:Player, amt:int):
	bids[p] = max(bids.get(p, 0), amt)

func close():
	var win:Player = null; var high := -1
	for p in bids: if bids[p] > high: high = bids[p]; win = p
	if win:
		win.gold -= high
		win.structures.append(current)
	emit_signal("auction_close", current, win)
	current = null
