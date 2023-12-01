extends Node

@onready var game_state_machine: IStateMachine = $"../GameStateMachine"
@onready var block_state_machine: IStateMachine = $"../BlockStateMachine"

func _ready():
	pass

func _process(_delta):
	pass

func _on_play_pressed():
	game_state_machine._change_state("playing")
	block_state_machine._change_state("spawning")
