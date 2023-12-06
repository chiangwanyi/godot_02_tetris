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
	if grid_matrix.has_overlap(block_spawn_pos, Shared.cells[block.type], 1):
		return false
	else:
		moving_block = block
		draw_tetromino(block)
		return true

# 绘制当前方块Tiles
func draw_tetromino(block: Block):
	for cell in Shared.cells[block.type].filter_value(1):
		var pos = origin_of_tilemap + block_spawn_pos + cell
		set_cell(layer, pos, 0, Shared.tiles_pos[block.type])