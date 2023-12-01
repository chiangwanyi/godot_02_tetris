extends "res://Utils/state_machine/state.gd"

@export var hud: CanvasLayer

func get_class_name():
	return "game_state:ready"

func enter():
	Logger.info(self, "游戏启动", [])
	hud.show()
	
func exit():
	hud.hide()
