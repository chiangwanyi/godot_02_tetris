extends Node

# 游戏TileMap
@onready var grid = $TileMap

@onready var input_timer = $InputTimer
@onready var tetromino_down_timer = $TetrominoDownTimer

# 游戏TileMap区域
var bounds = {
	# X轴范围，方块Tile坐标不超过以下值
	"x": [-6, 5],
	# Y轴范围，方块Tile坐标不超过以下值
	"y": [-13, 12]
}

# 绘制的TileMap layer
var layer = 1

# 已固定的方块坐标
var fixed_cells : Array[Vector2i] = []

# 当前方块类型
var current_tetromino_type : Shared.Tetromino

# 当前方块的root块坐标
var current_tetromino_root_pos : Vector2i

# 当前是否存在正在移动的方块
var has_movement_tetromino = false

var can_input = false

var droped = false

func _ready():
	spawn_tetromino_random()
	reset_input_timer()

# 随机生成一种方块
func spawn_tetromino_random():
	if has_movement_tetromino:
		return
	# 随机生成一种方块
	current_tetromino_type = Shared.Tetromino.values().pick_random()
	has_movement_tetromino = true
	spawn_tetromino(current_tetromino_type)

# 生成方块
func spawn_tetromino(type: Shared.Tetromino):
	var spawn_position = Shared.spawn_root_pos[type]
	current_tetromino_root_pos = spawn_position
	draw_tetromino(type, current_tetromino_root_pos)
	
# 清除当前方块Tiles
func clear_current_tetromino():
	for cell in Shared.cells[current_tetromino_type]:
		grid.set_cell(layer, current_tetromino_root_pos + cell, -1, Shared.tiles_pos[current_tetromino_type])

# 绘制当前方块Tiles
func draw_tetromino(type: Shared.Tetromino, tetromino_root_pos: Vector2i):
	for cell in Shared.cells[type]:
		grid.set_cell(layer, tetromino_root_pos + cell, 0, Shared.tiles_pos[type])

func stop_tetromino_down():
	if tetromino_down_timer.is_stopped():
		tetromino_down_timer.start(1)
	else:
		tetromino_down_timer.stop()

# 当前方块下落
func down_tetromino():
	if not has_movement_tetromino:
		return
	
	# 尝试移动方块
	var temp_root_pos = current_tetromino_root_pos + Vector2i(0, 1)
	
	# 检查方块是否能够移动
	var can_move = true
	for cell in Shared.cells[current_tetromino_type]:
		var real_cell_pos = temp_root_pos + cell
		# 检查是否超出边界
		if is_out_of_bounds(real_cell_pos):
			can_move = false
			break
		# 检查是否碰到已经固定的方块
		if is_cell_fixed(real_cell_pos):
			can_move = false
			break

	if can_move:
		clear_current_tetromino()
		# 如果可以移动，则更新root坐标并绘制方块
		current_tetromino_root_pos = temp_root_pos
		draw_tetromino(current_tetromino_type, current_tetromino_root_pos)
	else:
		print("freeze")
		# 如果不能移动，则固定当前方块
		fix_current_tetromino()
		
		spawn_tetromino_random()

func fix_current_tetromino():
	for cell in Shared.cells[current_tetromino_type]:
		var real_cell_pos = current_tetromino_root_pos + cell
		# 确保不添加重复的坐标
		if not fixed_cells.has(real_cell_pos):
			fixed_cells.append(real_cell_pos)
			
	tetromino_down_timer.start(1)
			
	current_tetromino_root_pos = Vector2i.ZERO

func is_cell_fixed(pos: Vector2i) -> bool:
	return fixed_cells.has(pos)

# 判断方块是否超出了边界
func is_out_of_bounds(real_cell_pos: Vector2i) -> bool:
	return real_cell_pos.x < bounds["x"][0] or real_cell_pos.x > bounds["x"][1] or real_cell_pos.y > bounds["y"][1]

# 移动或重新绘制方块的公共代码
func move_or_draw(temp_root_pos):
	var can_move = true
	for cell in Shared.cells[current_tetromino_type]:
		var real_cell_pos = temp_root_pos + cell
		if is_out_of_bounds(real_cell_pos) or is_cell_fixed(real_cell_pos):
			can_move = false
			break

	if can_move:
		current_tetromino_root_pos = temp_root_pos

	draw_tetromino(current_tetromino_type, current_tetromino_root_pos)

# 直接让当前方块下落到底部
func drop_tetromino():
	droped = true
	tetromino_down_timer.start(0.01)
	#while not is_cell_fixed(current_tetromino_root_pos + Vector2i(0, 1)) and not is_out_of_bounds(current_tetromino_root_pos + Vector2i(0, 1)):
	#	down_tetromino()
		
# 移动当前方块到左边
func move_tetromino_left():
	if (current_tetromino_root_pos == null):
		return
	clear_current_tetromino()

	var temp_root_pos = current_tetromino_root_pos + Vector2i(-1, 0)
	move_or_draw(temp_root_pos)

# 移动当前方块到右边
func move_tetromino_right():
	if (current_tetromino_root_pos == null):
		return
	clear_current_tetromino()

	var temp_root_pos = current_tetromino_root_pos + Vector2i(1, 0)
	move_or_draw(temp_root_pos)

# 顺时针旋转当前方块
func rotate_tetromino_clockwise():
	if (current_tetromino_root_pos == null):
		return
	clear_current_tetromino()

	var new_cells = []
	for cell in Shared.cells[current_tetromino_type]:
		var new_pos = Shared.clockwise_rotation_matrix[0] * cell.x + Shared.clockwise_rotation_matrix[1] * cell.y
		new_cells.append(Vector2i(new_pos.x, new_pos.y))

	# 检查旋转后是否有冲突
	var can_rotate = true
	for new_cell in new_cells:
		var real_cell_pos = current_tetromino_root_pos + new_cell
		if is_out_of_bounds(real_cell_pos) or is_cell_fixed(real_cell_pos):
			can_rotate = false
			break

	if can_rotate:
		Shared.cells[current_tetromino_type] = new_cells
		draw_tetromino(current_tetromino_type, current_tetromino_root_pos)
	else:
		draw_tetromino(current_tetromino_type, current_tetromino_root_pos)

func _process(_delta):
	if can_input:
		if Input.is_action_pressed("move_right"):
			move_tetromino_right()
			reset_input_timer()
		if Input.is_action_pressed("move_left"):
			move_tetromino_left()
			reset_input_timer()
		if Input.is_action_pressed("move_down") && !droped:
			droped = true
			tetromino_down_timer.start(0.01)
		if Input.is_action_just_released("move_down") && droped:
			droped = false
			tetromino_down_timer.start(1)
		if Input.is_action_pressed("rotate"):
			rotate_tetromino_clockwise()
			reset_input_timer()


func _on_input_timer_timeout():
	can_input = true
	
func reset_input_timer():
	can_input = false
	input_timer.start()
