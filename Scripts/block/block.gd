class_name Block extends Node

var type: Shared.Tetromino

func _init(_type: Shared.Tetromino = Shared.Tetromino.values().pick_random()):
	type = _type
