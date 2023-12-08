extends "res://Utils/state_machine/state.gd"

@export var block_moving_interval: float = 1.5
@onready var grid: Grid = $"../../Grid"

var elapsed_time: float = 0

func get_class_name():
	return "block_state:moving"

func enter():
	Logger.info(self, "start moving", [])

func update(delta):
	elapsed_time += delta
	if elapsed_time >= block_moving_interval:
		Logger.info(self, "moving", [])
		grid.draw_tetromino(grid.moving_block)
		elapsed_time = 0

func exit():
	elapsed_time = 0
	Logger.info(self, "exit moving", [])
