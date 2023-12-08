extends "res://Utils/state_machine/state.gd"

@onready var grid: Grid = $"../../Grid"
var move_frequency = 0.2 # 移动频率，以秒为单位
var time_since_last_move_right = 0.0 # 向右移动后的时间
var time_since_last_move_left = 0.0 # 向左移动后的时间

func get_class_name():
	return "block_state:moving"

func enter():
	Logger.info(self, "start moving", [])
	time_since_last_move_right = 0.0
	time_since_last_move_left = 0.0

func update(delta):
	time_since_last_move_right += delta
	time_since_last_move_left += delta

	if Input.is_action_pressed("move_right") and time_since_last_move_right >= move_frequency:
		move_tetromino_right()
		time_since_last_move_right = 0.0

	if Input.is_action_pressed("move_left") and time_since_last_move_left >= move_frequency:
		move_tetromino_left()
		time_since_last_move_left = 0.0

	if Input.is_action_pressed("move_down"):
		move_tetromino_down()
		pass


func move_tetromino_down():
	grid.move_tetromino(grid.moving_block, Vector2i(0, 1))
	grid.draw()	

func move_tetromino_right():
	grid.move_tetromino(grid.moving_block, Vector2i(1, 0))
	grid.draw()

func move_tetromino_left():
	grid.move_tetromino(grid.moving_block, Vector2i(-1, 0))
	grid.draw()

func exit():
	Logger.info(self, "exit moving", [])
