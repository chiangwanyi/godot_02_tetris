# 所有状态的基类
class_name IState extends Node

# warning-ignore:unused_signal
signal finished(next_state_name)

func get_class_name():
	pass

# 状态进入时. E.g. change the animation.
func enter():
	pass


# 状态退出时. Reinitialize values like a timer.
func exit():
	pass


func handle_input(_event):
	pass


func update(_delta):
	pass


func _on_animation_finished(_anim_name):
	pass
