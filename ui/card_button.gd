extends Button
class_name CardButton

## Ce script est instancié par CardButton.tscn
## Il gère le drag-and-drop d’une carte depuis la main vers le plateau.

var card_data : Card
@onready var anim : AnimationPlayer = $Anim

const EFFECT_SPAWN_PATH := "res://assets/effects/spawn_effect.png"
const EFFECT_ATTACK_PATH := "res://assets/effects/attack_effect.png"
const EFFECT_DESTROY_PATH := "res://assets/effects/destroy_effect.png"

# Percentage of the screen width this button should occupy.
@export var size_ratio : float = 0.1

const CARD_TEXTURES := {
	"Forest": preload("res://assets/cards/forest_card.png"),
	"Desert": preload("res://assets/cards/desert_card.png"),
	"Reef": preload("res://assets/cards/reef_card.png"),
	"Swamp": preload("res://assets/cards/swamp_card.png"),
	"Tundra": preload("res://assets/cards/tundra_card.png"),
	"Volcano": preload("res://assets/cards/volcano_card.png"),
	"Neutral": preload("res://assets/cards/neutral_structure.png")
}

signal dragged(card : Card)

func _ready() -> void:
	text = ""
	icon = CARD_TEXTURES.get(card_data.biome, CARD_TEXTURES["Neutral"])
	expand_icon = true
	var width := get_viewport_rect().size.x * size_ratio
	custom_minimum_size = Vector2(width, width * 1.5)

	# tooltip avec coût et statistiques
	var cost := 3
	match card_data.card_type:
		constants.CardType.UNIT:
			cost = 2
		constants.CardType.SPELL:
			cost = 1

	var stat_text := ""
	if card_data.card_type == constants.CardType.UNIT:
		stat_text = "%d/%d" % [card_data.atk, card_data.hp]
	elif card_data.card_type == constants.CardType.STRUCTURE:
		stat_text = "HP: %d" % card_data.hp

	var effects_text : Array[String] = []
	for s in constants.SEASON_NAMES:
		if card_data.effects.has(s):
			var e: Dictionary = card_data.effects[s]
			var desc := constants.describe_effect(e)
			var season : Variant = constants.SEASON_LABELS.get(s, s.capitalize())
			effects_text.append("%s: %s" % [season, desc])

	tooltip_text = "Coût: %d\nStats: %s\n%s" % [cost, stat_text, "\n".join(effects_text)]

	var box := VBoxContainer.new()
	box.anchor_left = 0.0
	box.anchor_top = 0.0
	box.anchor_right = 1.0
	box.anchor_bottom = 1.0

	var icon_rect := TextureRect.new()
	icon_rect.expand = true
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_rect.texture = CARD_TEXTURES.get(card_data.biome, CARD_TEXTURES["Neutral"])
	box.add_child(icon_rect)

	var lbl_name := Label.new()
	lbl_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_name.text = card_data.name
	box.add_child(lbl_name)

	var lbl_stats := Label.new()
	lbl_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_stats.text = stat_text
	box.add_child(lbl_stats)

	var lbl_cost := Label.new()
	lbl_cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_cost.text = "Cost: %d" % cost
	box.add_child(lbl_cost)

	var lbl_eff := Label.new()
	lbl_eff.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_eff.autowrap_mode = TextServer.AUTOWRAP_WORD
	lbl_eff.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl_eff.text = "Eff: %s" % " | ".join(effects_text)
	box.add_child(lbl_eff)

	add_child(box)
	pressed.connect(_on_pressed)

func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("dragged", card_data)

func _on_pressed() -> void:
	emit_signal("dragged", card_data)

func play_spawn() -> void:
	scale = Vector2.ZERO
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.2)
	_show_effect(EFFECT_SPAWN_PATH)

func play_attack() -> void:
	var tw := create_tween()
	tw.tween_property(self, "scale", Vector2.ONE * 1.2, 0.1)
	tw.tween_property(self, "scale", Vector2.ONE, 0.1)
	_show_effect(EFFECT_ATTACK_PATH)

func play_destroy() -> void:
	create_tween().tween_property(self, "modulate:a", 0.0, 0.2)
	_show_effect(EFFECT_DESTROY_PATH)
	
func _show_effect(path:String) -> void:
	var tex := load(path)
	if tex == null:
	return
	var s := Sprite2D.new()
	s.texture = tex
	s.centered = true
	add_child(s)
	var tw := create_tween()
	tw.tween_property(s, "modulate:a", 0.0, 0.25)
	tw.tween_callback(Callable(s, "queue_free"))
