extends "res://Utils/state_machine/state.gd"

@export var hud: CanvasLayer

func enter():
	hud.show()
	
func exit():
	hud.hide()
