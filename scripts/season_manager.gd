extends Node
# class_name SeasonManager

signal season_start(season : int)
signal season_end(season   : int)
signal segment_tick(season : int, segment : int)

const SEGMENTS_PER_SEASON := 4
const SEASON_BIOMES := {
	"spring": "Forest",
	"summer": "Desert",
	"autumn": "Swamp",
	"winter": "Tundra"
}
var season  : int
var segment : int

func _ready() -> void:
	reset()

func reset() -> void:
	season  = constants.Season.SPRING
	segment = 0
	emit_signal("season_start", season)

func current() -> String:
	return constants.SEASON_NAMES[season]

func current_biome() -> String:
	return SEASON_BIOMES.get(current(), "Forest")

func advance_segment() -> void:
	segment += 1
	if segment >= SEGMENTS_PER_SEASON:
		emit_signal("season_end", season)
		segment = 0
		season  = (season + 1) % 4
		emit_signal("season_start", season)
	emit_signal("segment_tick", season, segment)
