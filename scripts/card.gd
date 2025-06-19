class_name Card
extends Resource

@export var cid      : String
@export var name     : String
@export var card_type: int
@export var biome    : String
@export var atk      : int
@export var hp       : int
@export var max_hp   : int
@export var effects  : Dictionary        # par saison ou clés spéciales

var owner  : Player
var charge : int = 0
var status : Dictionary = {
	"burn":0, "poison":0, "rooted":false, "sleep":0,
	"camouflage":false, "frozen":0
}

func copy() -> Card:
	return duplicate()

func damage(v : int) -> void:
	hp -= v
	if hp <= 0:
		BattleManager.destroy(self)
