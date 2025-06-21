extends ConfirmationDialog
class_name MarketDialog

@export var market_path : NodePath
var market : MarketManager
@onready var amount : SpinBox = $BidAmount
@onready var bid_btn : Button = $BidButton

func _ready() -> void:
	market = get_node(market_path)

	# Godot 4 : connect(signal_name : String, callable : Callable)
	market.connect("auction_open",  Callable(self, "_on_open"))
	market.connect("auction_close", Callable(self, "_on_close"))
	bid_btn.pressed.connect(_on_bid_pressed)
	confirmed.connect(_on_confirmed)

# ------------------------------------------------------------- callbacks
func _on_open(card : Card) -> void:
	title       = "Enchère : " + card.name
	dialog_text = "Misez de l'or pour obtenir cette Structure."
	visible     = true

func _on_close(card : Card, winner : Player) -> void:
	visible = false

func _on_bid_pressed() -> void:
	var player := get_tree().get_first_node_in_group("local_player")
	if player:
	market.bid(player, int(amount.value))

func _on_confirmed() -> void:
	market.close()
