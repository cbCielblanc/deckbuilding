extends CanvasLayer
class_name TutorialOverlay

@onready var label : Label = $Panel/Label

func show_tip(msg : String) -> void:
	label.text = msg
	visible = true

@warning_ignore("native_method_override")
func hide() -> void:
	self.hide()
	visible = false
