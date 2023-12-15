class_name Matrix2D

# 二维矩阵，表示rows行columns列，矩阵原点(0,0)位于左上角
var data: Array = []
# 矩阵的行数
var rows : int = 0
# 矩阵的列数
var columns : int = 0
# 矩阵中的元素空值
var empty_value: Variant

# 属于该矩阵的子矩阵，即矩阵A可重叠在矩阵B上，A是B的子矩阵
var children: Array[Matrix2D] = []
# 子矩阵原点在父矩阵的起始位置（即相对于父矩阵原点则为偏移量），key为子矩阵自身Matrix2D，value为起始位置坐标Vector2i
var child_pos_map = {}

func _init(row: int, col: int, _empty_value: Variant = 0, init_data: Array = []):
	self.rows = row
	self.columns = col
	self.empty_value = _empty_value

	# 初始化 data 数组
	self.data.clear()
	for i in range(self.rows):
		var row_data: Array = []
		for j in range(self.columns):
			if init_data.size() != 0 and i < init_data.size() and j < init_data[i].size():
				row_data.append(init_data[i][j])
			else:
				row_data.append(self.empty_value)
		self.data.append(row_data)

# 深拷贝一个矩阵
func duplicate() -> Matrix2D:
	var new_matrix = Matrix2D.new(self.rows, self.columns, self.empty_value, self.data)
	return new_matrix

# 获取row行col列的元素
func get_value(row: int, col: int) -> Variant:
	if row < 0 or row >= self.rows or col < 0 or col >= self.columns:
		return null  # 或其他适当的错误值
	return self.data[row][col]

# 设置row行col列的元素值
func set_value(row: int, col: int, value: Variant):
	if row >= 0 and row < self.rows and col >= 0 and col < self.columns:
		self.data[row][col] = value

# 值是否相斥
func is_value_exclude(v1: Variant, v2: Variant) -> bool:
	if v1 == 0 or v2 == 0:
		return false
	return true
	
# 打印矩阵，包含坐标轴和分割线
func print_matrix():
	var matrix_string := "   "  # 顶部的空格用于对齐

	# 打印列号
	for j in range(self.columns):
		matrix_string += str(j) + " "
	matrix_string += "\n"

	# 打印列号下的分割线
	matrix_string += "  +"
	for i in range(self.columns):
		matrix_string += "--"
	matrix_string += "\n"

	# 打印矩阵行和行号
	for i in range(self.rows):
		matrix_string += str(i) + " |"  # 行号和纵向分割线
		for j in range(self.columns):
			matrix_string += str(self.data[i][j]) + " "
		matrix_string += "\n"

	print(matrix_string)

func set_child_data(child: Matrix2D, pos: Vector2i):
	for i in range(child.rows):
		for j in range(child.columns):
			var value = child.get_value(i, j)
			if value != empty_value:
				set_value(i + pos.y, j + pos.x, value)

func clear_child_data(child: Matrix2D):
	var current_position: Vector2i = child_pos_map[child]

	for i in range(child.rows):
		for j in range(child.columns):
			var value = child.get_value(i, j)
			if value != empty_value:			
				set_value(current_position.y + i, current_position.x + j, empty_value)

func update_child_data(child: Matrix2D, pos: Vector2i):
	clear_child_data(child)
	set_child_data(child, pos)

# child是否出界
func is_out_of_bound(child: Matrix2D, child_pos: Vector2i) -> bool:
	for i in range(child.rows):
		for j in range(child.columns):
			var value = child.get_value(i, j)
			if value == empty_value:
				continue
			var cx = child_pos.x + j
			var cy = child_pos.y + i
			if cx < 0 or cx >= self.columns or cy < 0 or cy >= self.rows:
				Logger.warn(self, "out of bound")
				return true
	return false

# 判断child矩阵放置到child_pos时是否与该位置的值重叠（用is_value_exclude判断，返回true表示重叠）
func is_overlapping(child: Matrix2D, child_pos: Vector2i) -> bool:
	# 先从逻辑上将child从父矩阵data中移除（若child在children中）
	if children.has(child):
		clear_child_data(child)
		
	var result = false
	for i in range(child.rows):
		for j in range(child.columns):
			var value = child.get_value(i, j)
			if value == empty_value:
				continue
			if is_value_exclude(value, get_value(child_pos.y + i, child_pos.x + j)):
				result = true
				break
	
	if children.has(child):
		set_child_data(child, child_pos_map[child])

	if result:
		Logger.warn(self, "is_overlapping")
	# 判断新位置是否重叠
	return result

# 添加子矩阵
func add_child_matrix(child: Matrix2D, child_pos: Vector2i) -> bool:
	# 检查子矩阵是否超出当前矩阵范围
	if is_out_of_bound(child, child_pos):
		return false

	if is_overlapping(child, child_pos):
		return false

	# 添加子矩阵
	children.append(child)
	child_pos_map[child] = child_pos

	# 更新父矩阵值
	set_child_data(child, child_pos)
	return true

func is_full(pos: Vector2i, width: int, height: int)-> bool:
	for y in range(pos.y, pos.y + height):
		for x in range(pos.x, pos.x + width - 1):
			if get_value(x, y) == empty_value:
				return false
	return true

# 90°顺旋转矩阵
func rotate_child_clockwise(child: Matrix2D) -> bool:
	var result = true
	if children.has(child):
		clear_child_data(child)

	# 获取当前子矩阵的位置
	var current_position: Vector2i = child_pos_map[child]

	# 创建旋转后的子矩阵
	var rotated_child = Matrix2D.new(child.columns, child.rows, child.empty_value)

	# 用旋转算法填充旋转后的子矩阵
	for i in range(child.rows):
		for j in range(child.columns):
			var value = child.get_value(i, j)
			rotated_child.set_value(child.columns - 1 - j, i, value)

	# 检查旋转后的子矩阵是否超出边界
	if is_out_of_bound(rotated_child, current_position):
		Logger.error(self, "Rotated child matrix is out of bounds.")
		result = false

	# 检查旋转后的子矩阵是否与其他子矩阵重叠
	if result and is_overlapping(rotated_child, current_position):
		Logger.error(self, "Rotated child matrix overlaps with other child matrices.")
		result = false

	if result:
		set_child_data(rotated_child, current_position)
		child.data = rotated_child.data
		child.rows = rotated_child.rows
		child.columns = rotated_child.columns
	else:
		set_child_data(child, current_position)

	return result

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

	# 创建一个临时的子矩阵来模拟移动
	var temp_child = child.duplicate()

	# 检查新位置是否超出父矩阵边界
	if is_out_of_bound(temp_child, new_position):
		return false

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
		
	# 更新父矩阵值
	clear_child_data(child)

	# 执行移动
	child_pos_map[child] = new_position

	set_child_data(child, new_position)
	return true

func get_class_name():
	return "matrix_2d"
