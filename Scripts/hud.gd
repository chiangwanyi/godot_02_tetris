extends CanvasLayer

signal spawn_new_tetromino
signal tetromino_stop_down

func _ready():
	pass


func _process(_delta):
	pass


func _on_test_spawn_tetromino_pressed():
	spawn_new_tetromino.emit()


func _on_test_tetromino_stop_down_pressed():
	tetromino_stop_down.emit()
