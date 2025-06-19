extends Node
signal event(tag : String, payload : Dictionary)

func emit(tag : String, payload : Dictionary = {}):
	emit_signal("event", tag, payload)
