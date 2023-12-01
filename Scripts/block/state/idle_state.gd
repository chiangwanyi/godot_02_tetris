extends "res://Utils/state_machine/state.gd"

func get_class_name():
	return "block_state:idle"

func enter():
	Logger.info(self, "start idle", [])

func exit():
	Logger.info(self, "exit idle", [])
