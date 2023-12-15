extends "res://Utils/state_machine/state.gd"

@onready var grid: Grid = $"../../Grid"

func get_class_name():
	return "block_state:spawning"

func enter():
	var block = Block.new()
	Logger.info(self, "生成Block:{}", [block.type])
	if grid.set_tetromino(block):
		grid.grid_matrix.print_matrix()
		grid.draw()
		emit_signal("finished", "moving")
	else:
		emit_signal("finished", "die")

	
