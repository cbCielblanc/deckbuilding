extends ConfirmationDialog
class_name MarketDialog

@export var market_path : NodePath
var market : MarketManager

func _ready() -> void:
	market = get_node(market_path)

	# Godot 4 : connect(signal_name : String, callable : Callable)
	market.connect("auction_open",  Callable(self, "_on_open"))
	market.connect("auction_close", Callable(self, "_on_close"))

# ------------------------------------------------------------- callbacks
func _on_open(card : Card) -> void:
	title       = "Enchère : " + card.name
	dialog_text = "Misez de l'or pour obtenir cette Structure."
	visible     = true

func _on_close(card : Card, winner : Player) -> void:
	visible = false
