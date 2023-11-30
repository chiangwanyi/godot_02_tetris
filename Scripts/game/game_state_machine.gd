extends "res://Utils/state_machine/state_machine.gd"

@onready var game_ready_state = $Ready
@onready var game_playing_state = $Playing

func _ready():
	states_map = {
		"ready": game_ready_state,
		"playing": game_playing_state
	}

func _change_state(state_name):
	if not _active:
		return
	super._change_state(state_name)

func get_class_name():
	return "game_state_machine"
