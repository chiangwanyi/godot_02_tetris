class_name Matrix2D

# 一个[x,y]矩阵（y行x列），[0,0]位于左上角
var data: Array[Array] = []
# 列数
var x : int = 0
# 行数
var y : int = 0

func _init(_x: int, _y: int, empty_value:int = 0, init_data: Array[Array] = []):
	x = _x
	y = _y
	for i in range(_y):
		var row = []
		for j in range(_x):
			if init_data.is_empty():
				row.append(empty_value)  # 初始化所有元素为0
			else:
				row.append(init_data[i][j])
		data.append(row)

func filter_value(target: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for i in range(y):
		for j in range(x):
			if data[i][j] == target:
				result.append(Vector2i(j, i))
	return result


func get_value(x : int, y : int) -> int:
	return data[y][x]

func set_value(x : int, y : int, value : int) -> void:
	data[y][x] = value

# 判断原点位于pos处的矩阵target是否与data矩阵
func some(pos: Vector2i, target: Array)	-> bool:
	# for i in range(target.size()):
	# 	for j in range(target[i].size()):

	return false
