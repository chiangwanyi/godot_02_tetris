extends "res://Utils/state_machine/state_machine.gd"

@onready var game_ready = $Ready
@onready var game_playing = $Playing

func _ready():
	states_map = {
		"ready": game_ready,
		"playing": game_playing
	}

func _change_state(state_name):
	if not _active:
		return
	super._change_state(state_name)
