extends "res://Utils/state_machine/state_machine.gd"

@onready var game_ready_state: IState = $Ready
@onready var game_playing_state: IState = $Playing

func _ready():
	states_map = {
		"ready": game_ready_state,
		"playing": game_playing_state
	}

func get_class_name():
	return "game_state_machine"
