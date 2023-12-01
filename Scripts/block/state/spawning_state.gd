extends "res://Utils/state_machine/state.gd"

@onready var grid: Grid = $"../../Grid"

func get_class_name():
	return "block_state:spawning"

func enter():
	var block = Block.new()
	Logger.info(self, "随机生成Block:{}", [block.type])
	grid.draw_tetromino(block)

	
