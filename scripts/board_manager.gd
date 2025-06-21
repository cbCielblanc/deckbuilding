extends Node
class_name BoardManager

var width  := 5
var height := 3
var grids  : Dictionary = {}				 # player -> 2-D array Card

# -------------------------------------------------------------- helpers
func _in_bounds(x:int, y:int) -> bool:
	return x >= 0 and y >= 0 and x < width and y < height

# -------------------------------------------------------------- init
func init_board(players:Array) -> void:
	grids.clear()
		for p in players:
		var g : Array = []
		for x in width:
			var col : Array = []
			for y in height:
				col.append(null)
			g.append(col)
		grids[p] = g
	EventBus.emit("board_changed")

# -------------------------------------------------------------- placement
func place_card(p, card:Card, x:int, y:int) -> bool:
	if !_in_bounds(x, y) or grids[p][x][y] != null:
		return false
	grids[p][x][y] = card
	card.owner = p
	if card.card_type == constants.CardType.UNIT:
		p.units.append(card)
	else:
		p.structures.append(card)
	Logger.info("Placed %s at %d,%d" % [card.name, x, y])
	p.emit_board()
	EventBus.emit("board_changed")
	return true

# -------------------------------------------------------------- déplacement
func move_unit(p, from_x:int, from_y:int, to_x:int, to_y:int) -> bool:
	if !_in_bounds(from_x,from_y) or !_in_bounds(to_x,to_y):
		return false
	var c : Card = grids[p][from_x][from_y]
	if c == null or c.card_type != constants.CardType.UNIT:
		return false
	if grids[p][to_x][to_y] != null:
		return false
	grids[p][from_x][from_y] = null
	grids[p][to_x][to_y]	 = c
	p.emit_board()
	EventBus.emit("board_changed")
	return true

# -------------------------------------------------------------- nettoyage
func remove_dead():
	for p in grids:
		for x in width:
			for y in height:
				var c : Card = grids[p][x][y]
				if c and c.hp <= 0:
					grids[p][x][y] = null
					Logger.info("%s destroyed at %d,%d" % [c.name, x, y])
					c.owner.emit_board()
					EventBus.emit("board_changed")
