extends Node
class_name TerrainManager

const WIDTH := 5
const HEIGHT := 3
const TILE_SIZE := 64

var tiles : Dictionary = {}				  # player -> 2-D array TerrainTile
# biome -> Array[Node2D] for each set of tiles sharing that biome
var biome_groups : Dictionary = {}
var _visual_root : Node2D
var _tile_scene : PackedScene = preload("res://scenes/TerrainTile.tscn")

func init(players:Array) -> void:
	if _visual_root:
		remove_child(_visual_root)
		_visual_root.queue_free()

	_visual_root = Node2D.new()
	add_child(_visual_root)

	tiles.clear()
	biome_groups.clear()

	var p_idx := 0
	for p in players:
		var group := Node2D.new()
		group.position = Vector2(p_idx * WIDTH * TILE_SIZE, 0)
		_visual_root.add_child(group)
		if !biome_groups.has(p.biome):
			biome_groups[p.biome] = []
		biome_groups[p.biome].append(group)

		var g := []
		for x in WIDTH:
			var col := []
			for y in HEIGHT:
				var t : TerrainTile = _tile_scene.instantiate()
				t.biome = p.biome
				t.position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
				group.add_child(t)
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

func groups_for_biome(b:String) -> Array[Node2D]:
	return biome_groups.get(b, [])

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
