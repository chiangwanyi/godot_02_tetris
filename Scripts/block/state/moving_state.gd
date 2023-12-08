extends "res://Utils/state_machine/state.gd"

@export var block_move_down_interval: float = 1.5
@export var block_move_vertical_interval: float = 0.5
@onready var grid: Grid = $"../../Grid"

var move_down_elapsed_time: float = 0
var move_vertical_elapsed_time: float = 0

func get_class_name():
	return "block_state:moving"

func enter():
	Logger.info(self, "start moving", [])

func update(delta):
	if Input.is_action_pressed("move_right"):
		move_tetromino_right(delta)
	if Input.is_action_pressed("move_left"):
		move_tetromino_left(delta)
	# if Input.is_action_pressed("move_down") && !droped:
	# 	droped = true
	# 	tetromino_down_timer.start(0.01)
	# if Input.is_action_just_released("move_down") && droped:
	# 	droped = false
	# 	tetromino_down_timer.start(1)
	# if Input.is_action_pressed("rotate"):
	# 	rotate_tetromino_clockwise()
	# 	reset_input_timer()
	move_down_elapsed_time += delta
	if move_down_elapsed_time >= block_move_down_interval:
		Logger.info(self, "moving", [])
		grid.draw_tetromino(grid.moving_block)
		move_down_elapsed_time = 0

func move_tetromino_right(delta):
	move_vertical_elapsed_time += delta
	if move_vertical_elapsed_time >= block_move_vertical_interval:
		Logger.info(self, "moving right", [])
		grid.draw_tetromino(grid.moving_block)
		move_vertical_elapsed_time = 0
	pass

func move_tetromino_left(delta):
	pass	

func exit():
	move_down_elapsed_time = 0
	Logger.info(self, "exit moving", [])
