extends Node
# class_name CardDatabase

var DATA : Dictionary

func _ready() -> void:
	var f := FileAccess.open("res://data/card_data.json", FileAccess.READ)
	DATA  = JSON.parse_string(f.get_as_text())

func _build(d : Dictionary) -> Card:
	var c := Card.new()
	c.cid  = d.id
	c.name = d.name

	# choix du type sans opérateur ?:
	if d.type == "structure":
		c.card_type = constants.CardType.STRUCTURE
	elif d.type == "spell":
		c.card_type = constants.CardType.SPELL
	else:
		c.card_type = constants.CardType.UNIT

	c.biome   = d.get("biome", "Neutral")
	c.atk     = d.get("atk", 0)
	c.hp      = d.get("hp",  0)
	c.max_hp  = c.hp
	c.effects = d.get("effects", {})
	return c

func neutral() -> Array[Card]:
	var out : Array[Card] = []
	for d in DATA.neutral_structures:
		out.append(_build(d))
	return out

func biome(b:String) -> Array[Card]:
	var out : Array[Card] = []
	for d in DATA.biome_cards.get(b, []):
		out.append(_build(d))
	return out
