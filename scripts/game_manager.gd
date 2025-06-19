extends Node
class_name GameManager

@export var biomes      : PackedStringArray = ["Forest", "Volcano"]
@export var ai_index    : int               = 1
@export var online_mode : bool              = false

@onready var market  := MarketManager.new()
@onready var board   := BoardManager.new()
@onready var terrain := TerrainManager.new()

var players  : Array[Player] = []
var turn_idx : int = 0

# ---------------------------------------------------------------- ready
func _ready() -> void:
	SeasonManager.reset()
	add_child(market)
	add_child(board)
	add_child(terrain)
	_spawn_players()
	board.init_board(players)
	terrain.init(players)
	_connect_signals()
	players[turn_idx].start_turn()

# ---------------------------------------------------------------- init joueurs
func _spawn_players() -> void:
	Logger.info("%s Join")
	for i in biomes.size():
		var p : Player
		if i == ai_index:
			p = preload("res://scripts/ai_pro.gd").new()
		else:
			p = preload("res://scripts/player.gd").new()

		p.name     = "Player%d" % i     # ← nom explicite, utile pour BoardUI paths
		p.biome    = biomes[i]
		p.is_human = (i != ai_index)
		add_child(p)
		players.append(p)

# ---------------------------------------------------------------- signaux
func _connect_signals() -> void:
	for p in players:
		p.connect("turn_end", Callable(self, "_on_turn_end"))
		p.connect("defeated", Callable(self, "_on_defeat"))

	SeasonManager.connect("season_end",   Callable(self, "_season_tick"))
	SeasonManager.connect("season_start", Callable(self, "_on_season_start"))

# ---------------------------------------------------------------- callbacks
func _on_turn_end(p : Player) -> void:
	BattleManager.full_attack(p, p.opponent())

	turn_idx = (turn_idx + 1) % players.size()
	if turn_idx == 0:
		SeasonManager.advance_segment()
		if SeasonManager.segment == 0:
			market.open()

	players[turn_idx].start_turn()

func _season_tick(_season:int) -> void:
	for pl in players:
		for u in pl.units:
			if u.status.burn   > 0: u.damage(u.status.burn)
			if u.status.poison > 0: u.damage(u.status.poison)
			if u.status.frozen > 0: u.status.frozen = 0

func _on_season_start(_season:int) -> void:
	terrain.season_update(SeasonManager.current())

func _on_defeat(p : Player) -> void:
	Logger.info("%s lost – Game Over" % p.name)
	get_tree().quit()

# ---------------------------------------------------------------- RPC helpers
func remote_play_card(_card_id:String, _owner_id:int) -> void:
	pass

func remote_end_turn(_owner_id:int) -> void:
	pass
