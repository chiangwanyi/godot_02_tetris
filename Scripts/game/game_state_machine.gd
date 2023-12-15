extends "res://Utils/state_machine/state_machine.gd"

@onready var game_ready_state: IState = $Ready
@onready var game_playing_state: IState = $Playing

func _ready():
	# var base = Matrix2D.new(20, 10)
	# var a = Shared.cells[Shared.Tetromino.J]
	# var b = Shared.cells[Shared.Tetromino.Z]
	# base.add_child_matrix(a, Vector2i(0, 0))
	# base.add_child_matrix(b, Vector2i(3, 0))
	# base.print_matrix()
	#print("==========")
	#base.clear_child_data(a)
	#base.set_child_data(a, base.child_pos_map[a])
	#base.move_child_matrix_orthogonally(a, Vector2i(1, 0))
	#base.print_matrix()

	
	# print(base.move_child_matrix(a, Vector2i(1, 0)))
	# base.print_matrix()
	# print(base.move_child_matrix(a, Vector2i(1, 0)))
	# base.print_matrix()
	# print(base.move_child_matrix(b, Vector2i(1, 0)))
	# base.print_matrix()
	# print(base.move_child_matrix(b, Vector2i(0, 1)))
	# base.print_matrix()
	# print(base.move_child_matrix(b, Vector2i(0, -1)))
	# base.print_matrix()
	# print(base.move_child_matrix(b, Vector2i(0, -1)))
	# base.print_matrix()	
	states_map = {
		"ready": game_ready_state,
		"playing": game_playing_state
	}
	

func get_class_name():
	return "game_state_machine"
