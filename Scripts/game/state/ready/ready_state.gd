extends "res://Utils/state_machine/state.gd"

@export var hud: CanvasLayer

func get_class_name():
	return "ready"

func enter():
	hud.show()
	
func exit():
	hud.hide()
