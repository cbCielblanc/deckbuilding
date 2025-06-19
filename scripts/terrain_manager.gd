extends Node
class_name TerrainManager

var tiles := {}        # player -> 2-D array TerrainTile

func init(players):
	for p in players:
		var g := []
		for x in 5:
			var col := []
			for y in 3:
				var t := TerrainTile.new()
				t.biome = p.biome
				col.append(t)
			g.append(col)
		tiles[p] = g

func season_update(season:String):
	for pl in tiles:
		for col in tiles[pl]:
			for t in col:
				t.apply_season(season)
