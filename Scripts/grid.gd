class_name Grid extends TileMap

# Grid原点相对于TileMap的位置
var origin_pos: Vector2i = Vector2i(9, 1)

# block生成的坐标点（左上角）
var block_spawn_pos: Vector2i = Vector2i(3, 0)

# 绘制的TileMap layer
var layer = 1

# # 游戏TileMap区域
# var bounds = {
# 	# X轴范围，方块Tile坐标不超过以下值
# 	"x": [9, 18],
# 	# Y轴范围，方块Tile坐标不超过以下值
# 	"y": [1, 20]
# }

# 已固定的方块坐标
var fixed_cells : Array[Vector2i] = []

func get_class_name():
	return "grid"

# 绘制当前方块Tiles
func draw_tetromino(block: Block):
	var cell = Shared.cells[block.type]
	for i in range(cell.size()):
		for j in range(cell[i].size()):
			if cell[i][j] == 1:
				set_cell(layer, origin_pos + block_spawn_pos + Vector2i(j, i), 0, Shared.tiles_pos[block.type])

# 		grid.set_cell(layer, tetromino_root_pos + cell, 0, Shared.tiles_pos[type])

