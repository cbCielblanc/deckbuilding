extends Node2D
class_name TerrainTile

const BIOME_TEXTURE_PATHS := {
	"forest": "res://assets/terrain/forest_tile.png",
	"desert": "res://assets/terrain/desert_tile.png",
	"reef": "res://assets/terrain/reef_tile.png",
	"swamp": "res://assets/terrain/swamp_tile.png",
	"tundra": "res://assets/terrain/tundra_tile.png",
	"volcano": "res://assets/terrain/volcano_tile.png",
}

var biome : String
var season_modifier : Dictionary = {}
var _base_color : Color = Color.WHITE

@onready var sprite : Sprite2D = $Sprite2D
@onready var shadow : Sprite2D = $Shadow
@onready var clickable : Control = $Clickable

func _ready() -> void:
	set_biome(biome)
	clickable.mouse_entered.connect(Callable(self, "_on_mouse_entered"))
	clickable.mouse_exited.connect(Callable(self, "_on_mouse_exited"))

	if sprite.texture == null:
		var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
		img.fill(Color.WHITE)
		var tex := ImageTexture.create_from_image(img)
		sprite.texture = tex
		shadow.texture = tex

func apply_season(season:String) -> void:
	if season_modifier.has(season):
		season_modifier[season].call()

func set_biome(b:String) -> void:
	biome = b
	var tex_path: String = BIOME_TEXTURE_PATHS.get(biome.to_lower(), "")
	if tex_path:
		var tex := load(tex_path)
		if tex:
			sprite.texture = tex
			shadow.texture = tex

func set_color(color:Color) -> void:
	_base_color = color
	sprite.modulate = _base_color

func highlight(on:bool) -> void:
	if on:
		sprite.modulate = _base_color.lightened(0.3)
	else:
		sprite.modulate = _base_color

func _on_mouse_entered() -> void:
	highlight(true)

func _on_mouse_exited() -> void:
	highlight(false)
