extends Node

@onready var game_state_machine = $"../StateMachine/Game"

func _ready():
	pass

func _process(_delta):
	pass

func _on_play_pressed():
	game_state_machine._change_state("playing")
