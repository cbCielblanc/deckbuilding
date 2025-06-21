extends Panel
class_name HistoryUI

@onready var log: RichTextLabel = $History

func _ready() -> void:
	EventBus.connect("event", Callable(self, "_on_event"))

func _on_event(tag: String, payload: Dictionary) -> void:
	if tag == "history":
		log.append_text(payload.get("msg", "") + "\n")
	elif tag == "card_destroyed":
		var c: Card = payload.get("card")
		if c:
			log.append_text("%s destroyed\n" % c.name)
