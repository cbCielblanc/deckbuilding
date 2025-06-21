extends HBoxContainer
class_name StatsUI

@export var player_path : NodePath
var player : Player
@onready var end_button : Button = $EndTurn

func _ready() -> void:
        player = get_node(player_path)
        if player.is_human:
                player.add_to_group("local_player")
        player.connect("stats_changed", Callable(self, "_refresh"))
        end_button.pressed.connect(_on_end_pressed)
        _refresh()

func _refresh(_p : Player = null) -> void:
	$Life.text = "Life: %d" % player.life
	$Gold.text = "Gold: %d" % player.gold
	$Essence.text = "Essence: %d" % player.essence
	$Mana.text = "Mana: %d" % player.mana

func _on_end_pressed() -> void:
	player.end_turn()
	EventBus.emit("event", {"tag":"turn_end"})
