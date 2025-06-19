extends Node
# class_name Logger

var verbose := true

func info(msg):
	if verbose:
		print("[INFO] ", msg)

func warn(msg):
	print("[WARN] ", msg)

func error(msg):
	push_error("[ERROR] " + str(msg))
