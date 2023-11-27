extends "res://Utils/state_machine/state.gd"

@export var hud: CanvasLayer

func enter():
	print("游戏主程序启动")
	hud.show()
	
func exit():
	print("游戏正准备开始")
	hud.hide()
