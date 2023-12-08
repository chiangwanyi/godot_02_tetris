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
var child_origin_offset = {}

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

# 查找矩阵中所有值与target相同的点，并返回他们的坐标
func filter_value(target: Variant) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for i in range(y):
		for j in range(x):
			if data[i][j] == target:
				result.append(Vector2i(j, i)) # 添加坐标到结果数组，注意列是x坐标，行是y坐标
	return result

# 值是否相斥
func is_value_exclude(v1: Variant, v2: Variant) -> bool:
	if v1 == 0 or v2 == 0:
		return false
	return v1 == v2

func print_matrix():
	for i in range(y):
		print(data[i])

			
# 添加子矩阵
func add_child_matrix(child: Matrix2D, origin_offset: Vector2i) -> bool:
	# 检查子矩阵是否超出当前矩阵范围
	if origin_offset.x < 0 or origin_offset.x + child.x > x or origin_offset.y < 0 or origin_offset.y + child.y > y:
		Logger.warn(self, "add child matrix failed: out of bound", [])
		return false

	# 检查子矩阵是否与现有子矩阵重叠
	for target in children:
		if not is_non_overlapping(child, origin_offset, target):
			return false

	# 添加子矩阵
	children.append(child)
	child_origin_offset[child] = origin_offset

	# 更新父矩阵值
	for i in range(child.y):
		for j in range(child.x):
			set_value(origin_offset.x + j, origin_offset.y + i, child.get_value(j, i))
	Logger.info(self, "add child matrix successful", [])			
	return true

# 移动子矩阵，以正交的方式
func move_child_matrix_orthogonally(child: Matrix2D, direction: Vector2i) -> bool:
	# 确保子矩阵在子矩阵列表中
	if not children.has(child):
		Logger.error(self, "The specified child matrix is not a child of this matrix.")
		return false

	# 获取当前子矩阵的位置
	var current_position: Vector2i = child_origin_offset[child]

	# 计算新位置
	var new_position: Vector2i = current_position + direction

	# 检查新位置是否超出父矩阵边界
	if new_position.x < 0 or new_position.x + child.x > x or new_position.y < 0 or new_position.y + child.y > y:
		Logger.warn(self, "matrix out of bound")
		return false

	# 创建一个临时的子矩阵来模拟移动
	var temp_child = child.duplicate()
	var temp_position: Vector2i = current_position

	# 检查移动路径上是否有障碍物
	while temp_position != new_position:
		# 按步移动temp_child，检查每一步是否有障碍物
		if direction.x != 0:
			temp_position.x += sign(direction.x) # 移动一步
		if direction.y != 0:
			temp_position.y += sign(direction.y) # 移动一步

		for target in children:
			if target == child:
				continue # 跳过当前子矩阵自身
			if not is_non_overlapping(temp_child, temp_position, target):
				return false # 如果移动路径上有障碍物，则移动失败

	# 执行移动
	child_origin_offset[child] = new_position

	# 更新父矩阵值
	for i in range(child.y):
		for j in range(child.x):
			set_value(current_position.x + j, current_position.y + i, empty_value)

	for i in range(child.y):
		for j in range(child.x):
			set_value(new_position.x + j, new_position.y + i, child.get_value(j, i))			
	return true


# 判断child矩阵放置到origin_offset时是否与target矩阵重叠
func is_non_overlapping(child: Matrix2D, origin_offset: Vector2i, target: Matrix2D) -> bool:
	# 获取target矩阵的原点偏移量
	var target_origin_offset = child_origin_offset[target]

	# 计算child矩阵的右下角坐标
	var child_bottom_right = Vector2i(origin_offset.x + child.x - 1, origin_offset.y + child.y - 1)
	# 计算target矩阵的右下角坐标
	var target_bottom_right = Vector2i(target_origin_offset.x + target.x - 1, target_origin_offset.y + target.y - 1)

	# 检查矩阵是否重叠
	# 如果child矩阵的左上角在target矩阵的右下角的右边或下边，或者
	# child矩阵的右下角在target矩阵的左上角的左边或上边，则这两个矩阵不重叠
	if origin_offset.x > target_bottom_right.x or origin_offset.y > target_bottom_right.y or child_bottom_right.x < target_origin_offset.x or child_bottom_right.y < target_origin_offset.y:
		return true

	# 如果以上条件都不满足，则说明矩阵重叠
	return false


func get_class_name():
	return "matrix_2d"
