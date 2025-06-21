extends Node2D
class_name GameManager

@export var biomes      : PackedStringArray = ["Forest", "Volcano"]
@export var ai_index    : int               = 1
@export var online_mode : bool              = false

@onready var market  := MarketManager.new()
@onready var board   := BoardManager.new()
@onready var terrain := TerrainManager.new()

var players  : Array[Player] = []
var turn_idx : int = 0

func play_card(card:Card, p:Player) -> void:
	var cost := 0
	match card.card_type:
		constants.CardType.UNIT: cost = 2
		constants.CardType.SPELL: cost = 1
		_: cost = 3
	if p.mana < cost:
		return
	p.mana -= cost
	p.emit_stats()
	p.hand.erase(card)
	p.emit_signal("hand_changed", p)

	if card.card_type == constants.CardType.SPELL:
		var eff : Dictionary = card.effects.get(SeasonManager.current(), {})
		var tgt : Card = null
		if p.opponent().units.size() > 0:
			tgt = p.opponent().units[0]
		EffectProcessor.apply(eff, card, tgt)
	else:
		var pos := _find_slot(p)
		if pos.x >= 0:
			board.place_card(p, card, pos.x, pos.y)
			board.remove_dead()

	EventBus.emit("history", {"msg": "%s plays %s" % [p.name, card.name]})
	EventBus.emit("card_played")

func _find_slot(p:Player) -> Vector2i:
	for y in board.height:
		for x in board.width:
			if board.grids[p][x][y] == null:
				return Vector2i(x, y)
	return Vector2i(-1, -1)

# ---------------------------------------------------------------- ready
func _ready() -> void:
	SeasonManager.reset()
	add_child(market)
	add_child(board)
	add_child(terrain)
	_spawn_players()
	_init_ui()
	board.init_board(players)
	terrain.init(players)
	_connect_signals()
	call_deferred("_start_first_turn")   # ← le tour commence à la frame suivante

func _start_first_turn() -> void:
	players[turn_idx].start_turn()

# ---------------------------------------------------------------- init joueurs
func _spawn_players() -> void:
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
		Logger.info("%s Join" % p.name)

func _init_ui() -> void:
	var ui := $UI
	var boards_panel := preload("res://scenes/BoardsPanel.tscn").instantiate()
	ui.add_child(boards_panel)
	for p in players:
		if p.is_human:
			var stats := preload("res://scenes/StatsUI.tscn").instantiate()
			stats.player_path = p.get_path()
			ui.add_child(stats)

			var hand := preload("res://scenes/HandUI.tscn").instantiate()
			hand.player_path = p.get_path()
			ui.add_child(hand)

		var board_ui := preload("res://scenes/BoardUI.tscn").instantiate()
		board_ui.player_path = p.get_path()
		board_ui.board_path  = board.get_path()
		board_ui.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		boards_panel.add_child(board_ui)

	var history := preload("res://scenes/HistoryUI.tscn").instantiate()
	ui.add_child(history)

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
	board.remove_dead()

	turn_idx = (turn_idx + 1) % players.size()
	if turn_idx == 0:
			SeasonManager.advance_segment()
			if SeasonManager.segment == 0:
					market.open()

	players[turn_idx].start_turn()

func _season_tick(_season:int) -> void:
	for pl in players:
		for u in pl.units:
			if u.status.burn   > 0:
		u.damage(u.status.burn)
			if u.status.poison > 0:
		u.damage(u.status.poison)
			if u.status.frozen > 0:
		u.status.frozen = 0
	board.remove_dead()

func _apply_season_effects() -> void:
	var season := SeasonManager.current()
	for pl in players:
		for c in pl.units + pl.structures:
			if c.effects.has(season):
		var eff : Dictionary = c.effects[season]
			var tgt : Card = c
		match eff.get("action", ""):
			"burn", "poison", "root", "freeze_unit", "blast":
		if pl.opponent().units.size() > 0:
			tgt = pl.opponent().units[0]
	else:
	tgt = null
	EffectProcessor.apply(eff, c, tgt)
	board.remove_dead()

func _on_season_start(_season:int) -> void:
terrain.season_update(SeasonManager.current())

	_apply_season_effects()

	var shop := BiomeShop.new()
	shop.biome = SeasonManager.current_biome()
	add_child(shop)

	var dialog : BiomeShopUI = preload("res://scenes/BiomeShopDialog.tscn").instantiate()
	dialog.shop_path = shop.get_path()
	$UI.add_child(dialog)
	shop.connect("bought", Callable(self, "_on_shop_bought").bind(dialog, shop))
	dialog.popup_centered()

func _on_shop_bought(_p:Player, _c:Card, dialog:BiomeShopUI, shop:BiomeShop) -> void:
	dialog.hide()
	shop._refill()

func _on_defeat(p : Player) -> void:
	Logger.info("%s lost – Game Over" % p.name)
	EventBus.emit("history", {"msg": "%s a perdu" % p.name})
	get_tree().quit()

# ---------------------------------------------------------------- RPC helpers
func remote_play_card(_card_id:String, _owner_id:int) -> void:
	var p := players[_owner_id]
	for c in p.hand:
		if c.cid == _card_id:
			play_card(c, p)
			break

func remote_end_turn(_owner_id:int) -> void:
	players[_owner_id].end_turn()
