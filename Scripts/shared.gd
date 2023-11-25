extends Node

# 七种不同形状的方块
enum Tetromino {
	I, J, L, O, S, T, Z
}

# 每种tetromino的初始格子布局，数值第0项表示root块（R块），之后的项分别表示其他块（O块）与R块的相对距离
var cells = {
	# 0 O R O
	Tetromino.I: [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0), Vector2i(-2, 0)],
	#   0
	#   R
	# O O
	Tetromino.J: [Vector2i(0, 0), Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 1)],
	# 0
	# R
	# O O
	Tetromino.L: [Vector2i(0, 0), Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 1)],
	# R O
	# O O
	Tetromino.O: [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)],
	#   R 0
	# O O
	Tetromino.S: [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 1)],
	#   R
	# O O O
	Tetromino.T: [Vector2i(0, 0), Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)],
	# 0 R
	#   O O
	Tetromino.Z: [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(1, 1)],
}

# 每种tetromino的初始生成坐标（root块坐标）
var spawn_root_pos = {
	Tetromino.I: Vector2i(-2, -10),
	Tetromino.J: Vector2i(0, -10),
	Tetromino.L: Vector2i(-1, -10),
	Tetromino.O: Vector2i(-1, -10),
	Tetromino.S: Vector2i(-1, -10),
	Tetromino.T: Vector2i(-1, -10),
	Tetromino.Z: Vector2i(0, -10),
	
}

# 每种tetromino的tile图集坐标
var tiles_pos = {
	Tetromino.I: Vector2i(1, 0),
	Tetromino.J: Vector2i(0, 0),
	Tetromino.L: Vector2i(3, 0),
	Tetromino.O: Vector2i(2, 1),
	Tetromino.S: Vector2i(2, 0),
	Tetromino.T: Vector2i(0, 1),
	Tetromino.Z: Vector2i(1, 1)
}

# 顺时针旋转矩阵
var clockwise_rotation_matrix = [Vector2(0, -1), Vector2(1, 0)]
# 逆时针旋转矩阵
var counter_clockwise_rotaion_matrix = [Vector2(0, 1), Vector2(-1, 0)]
