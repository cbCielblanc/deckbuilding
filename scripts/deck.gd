extends Node
class_name Deck

var cards : Array[Card] = []
var draw  : Array[Card] = []
var disc  : Array[Card] = []

func shuffle() -> void:
	draw = cards.duplicate()
	draw.shuffle()

func _reshuffle() -> void:
	draw  = disc.duplicate()
	disc.clear()
	draw.shuffle()

func draw_n(n : int) -> Array[Card]:
	var out : Array[Card] = []      # ← typage explicite
	for i in n:
		if draw.is_empty():
			_reshuffle()
		if draw.is_empty():
			break
		out.append(draw.pop_back())
	return out

func add(c : Card) -> void:
	cards.append(c)
