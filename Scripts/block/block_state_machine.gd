extends "res://Utils/state_machine/state_machine.gd"

@onready var block_idle_state: IState = $Idle
@onready var block_spawning_state: IState = $Spawning

func _ready():
	states_map = {
		"idle": block_idle_state,
		"spawning": block_spawning_state
	}

func get_class_name():
	return "block_state_machine"
