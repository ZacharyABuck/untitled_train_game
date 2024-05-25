extends TileMap

var altitude = FastNoiseLite.new()

var chunk_width = 11
var chunk_height = 9
var loaded_chunks: Array = []
var level_terrain: int

# Called when the node enters the scene tree for the first time.
func _ready():
	level_terrain = LevelInfo.level_parameters["terrain"]
	altitude.frequency = .5
	altitude.seed = randi()

func _process(delta):
	if PlayerInfo.active_player:
		var new_cells = spawn_chunk(local_to_map(PlayerInfo.active_player.global_position))
		BetterTerrain.update_terrain_cells(self, 0, new_cells)
		

func spawn_chunk(coords):
	var new_cells = []
	for x in range(chunk_width):
		for y in range(chunk_height):
			var cell = Vector2i(coords.x - (chunk_width / 2) + x, coords.y - (chunk_height / 2) + y)
			var alt = altitude.get_noise_2d(cell.x, cell.y) * 10
			if alt < 0 and !LevelInfo.track_cells.has(cell):
				BetterTerrain.set_cell(self, 0, cell, 0)
			elif !LevelInfo.track_cells.has(cell):
				var terrain = round(2 * (alt+level_terrain) / 20)
				BetterTerrain.set_cell(self, 0, cell, terrain)
			if coords not in loaded_chunks:
				loaded_chunks.append(coords)
			new_cells.append(cell)
	
	return new_cells


func set_track_cell(pos):
	var coords = local_to_map(pos)
	BetterTerrain.set_cell(self, 0, coords, 0)
	LevelInfo.track_cells.append(coords)
	for c in get_surrounding_cells(coords):
		if !LevelInfo.track_cells.has(c):
			LevelInfo.track_cells.append(c)
			BetterTerrain.set_cell(self, 0, c, 0)
			for cc in get_surrounding_cells(c):
				if !LevelInfo.track_cells.has(cc):
					LevelInfo.track_cells.append(cc)
					BetterTerrain.set_cell(self, 0, cc, 0)

func edge_reached(direction, body, entered_map):
	if body.is_in_group("player"):
		match direction:
			"left":
				if !LevelInfo.map_positions.has(entered_map.global_position + Vector2(-32*128,0)):
					spawn_chunk(entered_map.global_position + Vector2(-32*128,0))
			"bottom":
				if !LevelInfo.map_positions.has(entered_map.global_position + Vector2(0,32*128)):
					spawn_chunk(entered_map.global_position + Vector2(0,32*128))
			"right":
				if !LevelInfo.map_positions.has(entered_map.global_position + Vector2(32*128,0)):
					spawn_chunk(entered_map.global_position + Vector2(32*128,0))
			"top":
				if !LevelInfo.map_positions.has(entered_map.global_position + Vector2(0,-32*128)):
					spawn_chunk(entered_map.global_position + Vector2(0,-32*128))
