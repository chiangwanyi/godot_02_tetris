class_name Matrix2D

# 一个[x,y]矩阵（y行x列），[0,0]，即矩阵原点位于左上角
var data: Array[Array] = []
# 列数
var x : int = 0
# 行数
var y : int = 0

var ms = {}

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

# 将el放置到
func push(origin: Vector2i, el: Matrix2D):
	ms[el] = origin
	
# 判断原点位于pos处的矩阵target是否与data矩阵
func has_overlap(origin: Vector2i, target: Matrix2D, value: int) -> bool:
	for p in target.filter_value(value):
		var pos = origin + p
		if self.get_value(pos.x, pos.y) == value:
			return true
	return false
