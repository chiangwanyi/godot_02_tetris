extends Node

# 七种不同形状的方块
enum Tetromino { I = 1, J = 2, L = 3, O = 4, S = 5, T = 6, Z = 7}

var cells = {
	Tetromino.I: Matrix2D.new(4, 4, 0, [
		[0, 0, 0, 0],
		[Tetromino.I, Tetromino.I, Tetromino.I, Tetromino.I],
		[0, 0, 0, 0],
		[0, 0, 0, 0]
	]),
	Tetromino.J: Matrix2D.new(4, 4, 0, [
		[0, 0, 0, 0],
		[Tetromino.J, 0, 0, 0],
		[Tetromino.J, Tetromino.J, Tetromino.J, 0],
		[0, 0, 0, 0]
	]),
	Tetromino.L: Matrix2D.new(4, 4, 0, [
		[0, 0, 0, 0],
		[0, 0, 0, Tetromino.L],
		[0, Tetromino.L, Tetromino.L, Tetromino.L],
		[0, 0, 0, 0]
	]),
	Tetromino.O: Matrix2D.new(4, 4, 0, [
		[0, 0, 0, 0],
		[0, Tetromino.O, Tetromino.O, 0],
		[0, Tetromino.O, Tetromino.O, 0],
		[0, 0, 0, 0]
	]),
	Tetromino.S: Matrix2D.new(4, 4, 0, [
		[0, 0, 0, 0],
		[0, Tetromino.S, Tetromino.S, 0],
		[Tetromino.S, Tetromino.S, 0, 0],
		[0, 0, 0, 0]
	]),
	Tetromino.T: Matrix2D.new(4, 4, 0, [
		[0, 0, 0, 0],
		[0, Tetromino.T, 0, 0],
		[Tetromino.T, Tetromino.T, Tetromino.T, 0],
		[0, 0, 0, 0]
	]),
	Tetromino.Z: Matrix2D.new(4, 4, 0, [
		[0, 0, 0, 0],
		[Tetromino.Z, Tetromino.Z, 0, 0],
		[0, Tetromino.Z, Tetromino.Z, 0],
		[0, 0, 0, 0]
	])
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
