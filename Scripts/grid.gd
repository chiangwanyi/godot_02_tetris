class_name Grid extends TileMap

# Grid原点相对于TileMap的位置
var origin_of_tilemap: Vector2i = Vector2i(9, 1)

# block生成的坐标点（左上角）
var block_spawn_pos: Vector2i = Vector2i(3, 0)

# 绘制的TileMap layer
var layer = 1

var moving_block: Block

var grid_matrix : Matrix2D = Matrix2D.new(10, 20)

func get_class_name():
	return "grid"

func set_tetromino(block: Block)-> bool:
	var result = grid_matrix.add_child_matrix(block.data, block_spawn_pos)
	if result:
		moving_block = block
	return result

func draw():
	for i in range(grid_matrix.y):
		for j in range(grid_matrix.x):
			var pos = origin_of_tilemap + Vector2i(j, i)
			set_cell(layer, pos, -1)

	for i in range(grid_matrix.y):
		for j in range(grid_matrix.x):
			var pos = origin_of_tilemap + Vector2i(j, i)
			if grid_matrix.data[i][j] != grid_matrix.empty_value:
				set_cell(layer, pos, 0, Shared.tiles_pos[grid_matrix.data[i][j]])

func move_tetromino(block: Block, direction: Vector2i) -> bool:
	return grid_matrix.move_child_matrix_orthogonally(block.data, direction)
