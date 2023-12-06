class_name Matrix2D

# 一个[x,y]矩阵（y行x列），[0,0]，即矩阵原点位于左上角
var data: Array[Array] = []
# 列数
var x : int = 0
# 行数
var y : int = 0
# 属于该矩阵的子矩阵，即矩阵A可重叠在矩阵B上，A是B的子矩阵
var children: Array[Matrix2D] = []
# 子矩阵原点在父矩阵的起始位置（即相对于父矩阵原点则为偏移量），key为起始位置坐标Vector2i，value为子矩阵自身Matrix2D
var child_origin_offset = {}

# _init 初始化一个 y 行 x 列的二维矩阵。
func _init(_x: int, _y: int, default_value: Variant = 0, init_data: Array[Array] = []):
	x = _x
	y = _y
	for i in range(_y):
		var row = []
		for j in range(_x):
			if init_data.is_empty():
				row.append(default_value)  # 初始化所有元素为0
			else:
				row.append(init_data[i][j])
		data.append(row)

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

# # 将el矩阵加入到当前矩阵中
# func push(origin: Vector2i, el: Matrix2D):
# 	ms[el] = origin
# 	for i in range(el.y):
# 		for j in range(el.x):
# 			set_value(origin.x + j, origin.y, el.get_value(j, i))
	
# # 判断原点位于pos处的矩阵target是否与data矩阵
# func has_overlap(child_origin: Vector2i, target: Matrix2D, value: int) -> bool:
# 	for p in target.filter_value(value):
# 		var pos = child_origin + p
# 		if self.get_value(pos.x, pos.y) == value:
# 			return true
# 	return false

# 值是否相斥
func is_value_exclude(v1: Variant, v2: Variant) -> bool:
	if v1 == 0 or v2 == 0:
		return false
	return true

func print_matrix():
	for i in range(y):
		print(data[i])

			
# 添加子矩阵
func add_child_matrix(child: Matrix2D, origin_offset: Vector2i) -> bool:
	# 检查子矩阵是否超出当前矩阵范围
	if origin_offset.x < 0 or origin_offset.x + child.x > x or origin_offset.y < 0 or origin_offset.y + child.y > y:
		return false

	# 检查子矩阵是否与现有子矩阵重叠
	for existing_child_origin in child_origin_offset.keys():
		var existing_child = child_origin_offset[existing_child_origin]
		if not is_non_overlapping(existing_child, existing_child_origin, child, origin_offset):
			return false

	# 添加子矩阵
	children.append(child)
	child_origin_offset[origin_offset] = child

	# 更新父矩阵值
	for i in range(child.y):
		for j in range(child.x):
			set_value(origin_offset.x + j, origin_offset.y + i, child.get_value(j, i))	
	return true

# 判断两个子矩阵是否不重叠
func is_non_overlapping(child1: Matrix2D, offset1: Vector2i, child2: Matrix2D, offset2: Vector2i) -> bool:
	var x1 = offset1.x
	var y1 = offset1.y
	var x2 = offset2.x
	var y2 = offset2.y

	for i in range(child1.y):
		for j in range(child1.x):
			var x1_pos = x1 + j
			var y1_pos = y1 + i

			for k in range(child2.y):
				for l in range(child2.x):
					var x2_pos = x2 + l
					var y2_pos = y2 + k

					if x1_pos == x2_pos and y1_pos == y2_pos:
						if is_value_exclude(child1.get_value(j, i), child2.get_value(l, k)):
							return false
	return true
