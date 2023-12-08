class_name Block extends Node

var type: Shared.Tetromino
var data: Matrix2D

func _init(_type: Shared.Tetromino = Shared.Tetromino.values().pick_random()):
	type = _type
	data = Shared.cells[type].duplicate()
