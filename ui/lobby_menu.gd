extends Control
class_name LobbyMenu

@onready var host_btn    : Button   = $Center/VBox/HostButton
@onready var join_btn    : Button   = $Center/VBox/JoinButton
@onready var start_btn   : Button   = $Center/VBox/StartButton
@onready var ip_line     : LineEdit = $Center/VBox/IpLine
@onready var status_lbl  : Label    = $Center/VBox/Status
@onready var players_lbl : Label    = $Center/VBox/Players

var net : NetworkManager = null

func _ready() -> void:
        if not Engine.is_editor_hint():
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
                DisplayServer.window_set_size(Vector2i(1280, 720))
        start_btn.disabled = true
        players_lbl.text   = "Players: 1"
        status_lbl.text    = "Idle"

# ------------------------------------------------------------- boutons
func _on_HostButton_pressed() -> void:
	_launch(true)

func _on_JoinButton_pressed() -> void:
	_launch(false)

# ------------------------------------------------------------- lancement réseau
func _launch(hosting:bool) -> void:
	net = NetworkManager.new()
	net.is_host   = hosting
	net.target_ip = ip_line.text.strip_edges()
	add_child(net)

	# -------- connexions : 2 arguments (signal, callable) ----------
	net.connect("peer_joined",  Callable(self, "_on_peer_joined"))
	net.connect("peer_left",    Callable(self, "_on_peer_left"))
	net.connect("lobby_ready",  Callable(self, "_on_ready"))

	host_btn.disabled = true
	join_btn.disabled = true
	status_lbl.text   = "Hosting…" if hosting else "Joining…"


# ------------------------------------------------------------- callbacks réseau
func _on_peer_joined(id:int) -> void:
	players_lbl.text = "Players: %d" % (multiplayer.get_peers().size() + 1)

func _on_peer_left(id:int) -> void:
	players_lbl.text = "Players: %d" % (multiplayer.get_peers().size() + 1)

func _on_ready() -> void:
	status_lbl.text    = "Ready!  Press Start"
	start_btn.disabled = false

# ------------------------------------------------------------- démarrer partie
func _on_StartButton_pressed() -> void:
        if not Engine.is_editor_hint():
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
                DisplayServer.window_set_size(Vector2i(1920, 1080))
        var main := preload("res://scenes/Main.tscn").instantiate()
        get_tree().root.add_child(main)
        queue_free()
