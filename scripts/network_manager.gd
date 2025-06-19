extends Node
# class_name NetworkManager

signal peer_joined(id : int)
signal peer_left(id   : int)
signal lobby_ready()                       # déclenché quand ≥ 2 joueurs

@export var is_host   : bool   = true
@export var target_ip : String = "127.0.0.1"

const PORT := 24680
var peer : ENetMultiplayerPeer

# ---------------------------------------------------------------- bootstrap
func _ready() -> void:
	if is_host:
		_start_host()
	else:
		_start_client()

func _start_host() -> void:
	peer = ENetMultiplayerPeer.new()
	var err := peer.create_server(PORT, 8)
	if err != OK:
		push_error("Unable to host: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	peer.connect("peer_connected",    Callable(self, "_on_peer_connected"))
	peer.connect("peer_disconnected", Callable(self, "_on_peer_left"))
	Logger.info("Hosting on 0.0.0.0:%d" % PORT)

func _start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	var err := peer.create_client(target_ip, PORT)
	if err != OK:
		push_error("Unable to connect: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	peer.connect("peer_connected",    Callable(self, "_on_peer_connected"))
	peer.connect("peer_disconnected", Callable(self, "_on_peer_left"))
	Logger.info("Connecting to %s:%d" % [target_ip, PORT])

# ---------------------------------------------------------------- lobby helpers
func _on_peer_connected(id : int) -> void:
	emit_signal("peer_joined", id)
	_check_ready()

func _on_peer_left(id : int) -> void:
	emit_signal("peer_left", id)

func _check_ready() -> void:
	if multiplayer.get_peers().size() + 1 >= 2:
		emit_signal("lobby_ready")

# ---------------------------------------------------------------- gameplay RPC
@rpc("any_peer")
func rpc_play_card(card_id : String, owner_id : int) -> void:
	var gm := get_tree().root.get_node("Main")
	gm.remote_play_card(card_id, owner_id)

@rpc("any_peer")
func rpc_end_turn(owner_id : int) -> void:
	var gm := get_tree().root.get_node("Main")
	gm.remote_end_turn(owner_id)
