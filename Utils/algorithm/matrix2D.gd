class_name Matrix2D

# 一个[x,y]矩阵（y行x列），[0,0]，即矩阵原点位于左上角
var data: Array[Array] = []
# 列数
var x : int = 0
# 行数
var y : int = 0
# 默认空值
var empty_value: Variant = 0
# 属于该矩阵的子矩阵，即矩阵A可重叠在矩阵B上，A是B的子矩阵
var children: Array[Matrix2D] = []
# 子矩阵原点在父矩阵的起始位置（即相对于父矩阵原点则为偏移量），key为子矩阵自身Matrix2D，value为起始位置坐标Vector2i
var child_pos_map = {}

# _init 初始化一个 y 行 x 列的二维矩阵。
func _init(_x: int, _y: int, _empty_value: Variant = 0, init_data: Array[Array] = []):
	x = _x
	y = _y
	empty_value = _empty_value
	for i in range(_y):
		var row = []
		for j in range(_x):
			if init_data.is_empty():
				row.append(_empty_value)  # 初始化所有元素为0
			else:
				row.append(init_data[i][j])
		data.append(row)

func duplicate() -> Matrix2D:
	var dup = Matrix2D.new(x, y, empty_value, data)
	return dup

func get_value(_x: int, _y: int) -> Variant:
	return data[_y][_x]

func set_value(_x: int, _y: int, value: int) -> void:
	data[_y][_x] = value

# 判断child矩阵放置到child_pos时是否与该位置的值重叠（用is_value_exclude判断，返回true表示重叠）
func is_overlapping(child: Matrix2D, child_pos: Vector2i) -> bool:
	#Logger.info(self, "start check is overlapping")
	# 先从逻辑上将child从父矩阵data中移除（若child在children中）
	if children.has(child):
		#print("clearing...")
		clear_child_data(child)
		
	#print_matrix()	

	var result = false
	for i in range(child.y):
		for j in range(child.x):
			if is_value_exclude(child.get_value(j, i), get_value(child_pos.x + j, child_pos.y + i)):
				result = true
				break
	
	if children.has(child):
		set_child_data(child, child_pos_map[child])

	if result:
		Logger.warn(self, "is_overlapping")
	# 判断新位置是否重叠
	#Logger.info(self, "end check is overlapping")	
	return result

# 值是否相斥
func is_value_exclude(v1: Variant, v2: Variant) -> bool:
	if v1 == 0 or v2 == 0:
		return false
	return true

func print_matrix():
	for i in range(y):
		print(data[i])

# 添加子矩阵
func add_child_matrix(child: Matrix2D, child_pos: Vector2i) -> bool:
	#Logger.info(self, "start add childe")
	# 检查子矩阵是否超出当前矩阵范围
	if child_pos.x < 0 or child_pos.x + child.x > x or child_pos.y < 0 or child_pos.y + child.y > y:
		Logger.warn(self, "add child matrix failed: out of bound", [])
		return false

	if is_overlapping(child, child_pos):
		return false

	# 添加子矩阵
	children.append(child)
	child_pos_map[child] = child_pos

	# 更新父矩阵值
	set_child_data(child, child_pos)
	#Logger.info(self, "add child matrix successful")
	#print(children)
	return true

func set_child_data(child: Matrix2D, pos: Vector2i):
	for i in range(child.y):
		for j in range(child.x):
			var value = child.get_value(j, i)
			if value != empty_value:
				set_value(pos.x + j, pos.y + i, value)

func clear_child_data(child: Matrix2D):
	var current_position: Vector2i = child_pos_map[child]

	for i in range(child.y):
		for j in range(child.x):
			var value = child.get_value(j, i)
			if value != empty_value:			
				set_value(current_position.x + j, current_position.y + i, empty_value)

func update_child_data(child: Matrix2D, pos: Vector2i):
	clear_child_data(child)
	set_child_data(child, pos)


# 移动子矩阵，以正交的方式
func move_child_matrix_orthogonally(child: Matrix2D, direction: Vector2i) -> bool:
	# 确保子矩阵在子矩阵列表中
	if not children.has(child):
		Logger.error(self, "The specified child matrix is not a child of this matrix.")
		return false

	# 获取当前子矩阵的位置
	var current_position: Vector2i = child_pos_map[child]

	# 计算新位置
	var new_position: Vector2i = current_position + direction

	# 检查新位置是否超出父矩阵边界
	if new_position.x < 0 or new_position.x + child.x > x or new_position.y < 0 or new_position.y + child.y > y:
		Logger.warn(self, "matrix out of bound")
		return false

	# 创建一个临时的子矩阵来模拟移动
	#var temp_child = child.duplicate()
	var temp_position: Vector2i = current_position

	# 检查移动路径上是否有障碍物
	while temp_position != new_position:
		# 按步移动temp_child，检查每一步是否有障碍物
		if direction.x != 0:
			temp_position.x += sign(direction.x) # 移动一步
		if direction.y != 0:
			temp_position.y += sign(direction.y) # 移动一步

		if is_overlapping(child, temp_position):
			return false # 如果移动路径上有障碍物，则移动失败
		
		#clear_child_data(temp_child)

	# 更新父矩阵值
	clear_child_data(child)

	# 执行移动
	child_pos_map[child] = new_position

	set_child_data(child, new_position)
	return true

func get_class_name():
	return "matrix_2d"
