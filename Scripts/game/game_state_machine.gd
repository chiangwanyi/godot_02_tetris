extends "res://Utils/state_machine/state_machine.gd"

@onready var game_ready_state: IState = $Ready
@onready var game_playing_state: IState = $Playing

func _ready():
	var base = Matrix2D.new(10, 10, 0)
	var a = Matrix2D.new(3, 3, 0, [
		[1, 1, 1],
		[1, 0, 1],
		[1, 1, 1]
	])
	var b = Matrix2D.new(2, 2, 0, [
		[2, 2],
		[2, 2]
	])
	base.add_child_matrix(a, Vector2i(0, 0))
	base.add_child_matrix(b, Vector2i(3, 3))
	base.print_matrix()
	base.move_child_matrix(a, Vector2i(1, 0))
	print("=========")
	base.print_matrix()
	states_map = {
		"ready": game_ready_state,
		"playing": game_playing_state
	}

func get_class_name():
	return "game_state_machine"
