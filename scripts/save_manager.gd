extends Node
# class_name SaveManager

const SAVE_PATH := "user://run_save.json"

func save_run(game_state : Dictionary) -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(game_state))
	f.close()
	Logger.info("Run saved to " + SAVE_PATH)

func load_run() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var txt := f.get_as_text()
	f.close()
	Logger.info("Run loaded")
	return JSON.parse_string(txt)
