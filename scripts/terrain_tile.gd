class_name TerrainTile
var biome  : String
var season_modifier : Dictionary = {}     # "spring" -> Callable …

func apply_season(season:String):
	if season_modifier.has(season):
		season_modifier[season].call()
