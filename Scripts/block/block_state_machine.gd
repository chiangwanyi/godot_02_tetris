extends "res://Utils/state_machine/state_machine.gd"

@onready var block_idle_state: IState = $Idle
@onready var block_spawning_state: IState = $Spawning
@onready var block_moving_state: IState = $Moving

func _ready():
	states_map = {
		"idle": block_idle_state,
		"spawning": block_spawning_state,
		"moving": block_moving_state
	}

func get_class_name():
	return "block_state_machine"
