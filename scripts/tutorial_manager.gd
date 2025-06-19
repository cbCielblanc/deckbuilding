extends Node
class_name TutorialManager

@export var overlay_path : NodePath          # assigné depuis main_menu.gd
var overlay : TutorialOverlay
var step : int = 0
var tips := [
	"Bienvenue ! 1/4 – Choisis une carte et joue-la.",
	"Bien ! 2/4 – Termine ton tour avec le bouton Fin.",
	"Parfait ! 3/4 – Gagne ce combat.",
	"Super ! 4/4 – Ouvre la boutique et achète une carte."
]

func _ready() -> void:
	if overlay_path != NodePath():
		overlay = get_node(overlay_path)

func start():
	step = 0
	_show_tip()

# --------------------------------------------------------- gestion des actions
func on_action(tag:String):
	if step == 0 and tag == "card_played":  _next()
	elif step == 1 and tag == "turn_end":   _next()
	elif step == 2 and tag == "battle_win": _next()
	elif step == 3 and tag == "buy_card":   _next()

func _next():
	step += 1
	if step >= tips.size():
		_finish()
	else:
		_show_tip()

func _show_tip():
	if overlay:
		overlay.show_tip(tips[step])
	# get_node("/root/Main/TutorialOverlay").show_tip(tips[step])

func _finish():
	if overlay:
		overlay.hide_tip()
	Logger.info("Tutorial completed")
