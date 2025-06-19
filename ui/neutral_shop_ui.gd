extends PopupPanel
class_name NeutralShopUI

@export var market_path : NodePath
var market : MarketManager

func _ready() -> void:
	market = get_node(market_path)

	# Godot 4 : un seul paramètre après le nom du signal, de type Callable
	market.connect("auction_open",  Callable(self, "_open"))
	market.connect("auction_close", Callable(self, "_close"))

# ------------------------------------------------------------- callbacks
func _open(card : Card) -> void:
	$VBox/CardLabel.text = card.name
	show()

func _close(card : Card, winner : Player) -> void:
	hide()
