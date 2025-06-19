extends PopupPanel
class_name BiomeShopUI

@export var shop_path : NodePath
var shop : BiomeShop                                  # sera assigné dans _ready()

func _ready() -> void:
	shop = get_node(shop_path)
	# signal « bought » → rafraîchir l’UI
	shop.connect("bought", Callable(self, "_refresh"))
	_refresh()                                        # première construction

# ----------------------------------------------------------------- UI refresh
func _refresh(_dummy = null) -> void:
	var grid : GridContainer = $Grid

	# 1) vider proprement le conteneur
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	# 2) recréer un bouton par carte en stock
	for c in shop.stock:
		var btn := Button.new()
		btn.text = "%s  4G/2E" % c.name
		btn.pressed.connect(_on_buy.bind(c))
		grid.add_child(btn)

# ----------------------------------------------------------------- achat
func _on_buy(card : Card) -> void:
	var player := get_tree().get_first_node_in_group("local_player")
	shop.buy(player, shop.stock.find(card))
