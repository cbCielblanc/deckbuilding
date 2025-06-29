extends Control
class_name MainMenu

@onready var solo_btn   = $VBox/SoloButton
@onready var multi_btn  = $VBox/MultiButton
@onready var tuto_btn   = $VBox/TutoButton
@onready var quit_btn   = $VBox/QuitButton




func _ready() -> void:
	# Auto-connect derun in s signaux si besoin
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1280, 720))
	$VBox/SoloButton.pressed.connect(_on_SoloButton_pressed)
	$VBox/MultiButton.pressed.connect(_on_MultiButton_pressed)
	$VBox/TutoButton.pressed.connect(_on_TutoButton_pressed)
	$VBox/QuitButton.pressed.connect(_on_QuitButton_pressed)

func _on_SoloButton_pressed() -> void:
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_MultiButton_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1280, 720))
	get_tree().change_scene_to_file("res://scenes/LobbyMenu.tscn")

func _on_TutoButton_pressed() -> void:
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	var main := preload("res://scenes/Main.tscn").instantiate()
	get_tree().root.add_child(main)
	var tuto := preload("res://scripts/tutorial_manager.gd").new()
	var overlay := preload("res://scenes/TutorialOverlay.tscn").instantiate()
	main.add_child(overlay)
	main.add_child(tuto)
	tuto.overlay_path = overlay.get_path()
	tuto.start()

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
