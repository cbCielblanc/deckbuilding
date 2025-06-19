extends Control
class_name MainMenu

@onready var solo_btn   = $VBox/SoloButton
@onready var multi_btn  = $VBox/MultiButton
@onready var tuto_btn   = $VBox/TutoButton
@onready var quit_btn   = $VBox/QuitButton

func _ready() -> void:
	# Auto-connect des signaux si besoin
	$VBox/SoloButton.pressed.connect(_on_SoloButton_pressed)
	$VBox/MultiButton.pressed.connect(_on_MultiButton_pressed)
	$VBox/TutoButton.pressed.connect(_on_TutoButton_pressed)
	$VBox/QuitButton.pressed.connect(_on_QuitButton_pressed)

func _on_SoloButton_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_MultiButton_pressed():
	get_tree().change_scene_to_file("res://scenes/LobbyMenu.tscn")

func _on_TutoButton_pressed():
	var main := preload("res://scenes/Main.tscn").instantiate()
	get_tree().root.add_child(main)
	var tuto := preload("res://scripts/tutorial_manager.gd").new()
	main.add_child(tuto)
	tuto.start()

func _on_QuitButton_pressed():
	get_tree().quit()
