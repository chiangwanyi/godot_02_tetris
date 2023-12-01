extends "res://Utils/state_machine/state.gd"

@onready var score_value : Label = $"../../HUD/Score/Panel/ScoreValue"

var score = 0
var level = 0
var lines = 0

func get_class_name():
	return "game_state:playing"

func enter():
	Logger.info(self, "开始游戏", [])
	score = 0
	score_value.set_text(str(score))
	level = 0
	lines = 0
	
func exit():
	print("停止游戏")
