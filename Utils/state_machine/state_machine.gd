# 所有状态机的基类
class_name IStateMachine extends Node

signal state_changed(current_state)

# 初始状态
@export var start_state: NodePath

# 用于存储状态的字典
var states_map = {}

# 状态栈
var states_stack : Array[IState] = []

# 当前活动状态
var current_state : IState = null

# 状态机是否可用
var _active = false:
	set(value):
		_active = value
		set_active(value)

func get_class_name():
	return "state_machine"		

# 设置状态机状态
func set_active(value):
	Logger.info(self, "set_active:{}", [value])
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null


# 初始化状态机，当节点被添加到场景树时自动调用（此时节点已经成为场景的一部分，所有的节点和资源都已经准备好）。
func _enter_tree():
	if start_state.is_empty():
		start_state = get_child(0).get_path()
	for child in get_children():
		# 将每种状态的 finished 信号连接到 _change_state方法上
		var err = child.finished.connect(self._change_state)
		if err:
			printerr(err)
	initialize(start_state)


# 初始化状态机
func initialize(initial_state):
	print("<state_machine>[initialize] 初始化状态机【开始】, initial_state:", initial_state)
	_active = true
	states_stack.push_front(get_node(initial_state))
	current_state = states_stack[0]
	current_state.enter()


func _unhandled_input(event):
	current_state.handle_input(event)


func _physics_process(delta):
	current_state.update(delta)        


func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)


func _change_state(state_name):
	print("<state_machine>[_change_state] 状态机状态改变, current:", current_state, " now:", state_name)
	if not _active:
		return
	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]

	current_state = states_stack[0]
	emit_signal("state_changed", current_state)
		
	if state_name != "previous":
		current_state.enter()    
