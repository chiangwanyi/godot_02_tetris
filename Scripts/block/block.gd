class_name Block extends Node

var type: Shared.Tetromino

func _init():
	type = Shared.Tetromino.values().pick_random()
