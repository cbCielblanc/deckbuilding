extends Node
class_name TerrainManager

const WIDTH := 5
const HEIGHT := 3
const TILE_SIZE := 64

var tiles : Dictionary = {}				  # player -> 2-D array TerrainTile
var _visual_root : Node2D
var _tile_scene : PackedScene = preload("res://scenes/TerrainTile.tscn")

func init(players:Array) -> void:
	_visual_root = Node2D.new()
	add_child(_visual_root)

	var p_idx := 0
	for p in players:
		var g := []
		for x in WIDTH:
			var col := []
			for y in HEIGHT:
				var t : TerrainTile = _tile_scene.instantiate()
				t.biome = p.biome
				t.position = Vector2((p_idx * WIDTH + x) * TILE_SIZE,
						y * TILE_SIZE)
				_visual_root.add_child(t)
				col.append(t)
			g.append(col)
		tiles[p] = g
		p_idx += 1
	update_visuals()

func season_update(season:String) -> void:
	for pl in tiles:
		for col in tiles[pl]:
			for t in col:
				t.apply_season(season)
	update_visuals()

func update_visuals() -> void:
	var current_season := SeasonManager.current()
	for pl in tiles:
		for col in tiles[pl]:
			for t in col:
				t.set_color(_color_for(t.biome, current_season))

func _color_for(biome:String, season:String) -> Color:
	var base : Color = {
		"Forest": Color(0.2, 0.6, 0.2),
		"Volcano": Color(0.7, 0.2, 0.2),
		"Desert": Color(0.8, 0.75, 0.5),
		"Reef": Color(0.2, 0.5, 0.8),
		"Swamp": Color(0.3, 0.4, 0.3),
		"Tundra": Color(0.8, 0.8, 0.9)
	}.get(biome, Color.WHITE)

	match season:
		"winter":
			return base.lightened(0.3)
		"autumn":
			return base.darkened(0.2)
		_:
			return base
