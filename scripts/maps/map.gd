extends TileMap

var altitude = FastNoiseLite.new()

var chunk_width = 13.0
var chunk_height = 10.0
var loaded_chunks: Array = []
var level_terrain: int
var last_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	level_terrain = CurrentRun.world.current_level_info.level_parameters["terrain"]
	altitude.frequency = .5
	altitude.seed = randi()

func _process(_delta):
	if CurrentRun.world.current_player_info.active_player and CurrentRun.world.current_player_info.active_player.global_position.distance_to(last_pos) > 256:
		last_pos = CurrentRun.world.current_player_info.active_player.global_position
		var new_cells = spawn_chunk(local_to_map(CurrentRun.world.current_player_info.active_player.global_position))
		BetterTerrain.update_terrain_cells(self, 0, new_cells)
		
func spawn_chunk(coords):
	var new_cells = []
	for x in range(chunk_width):
		for y in range(chunk_height):
			var cell = Vector2i(coords.x - (chunk_width * .5) + x, coords.y - (chunk_height * .5) + y)
			var alt = altitude.get_noise_2d(cell.x, cell.y) * 10
			if alt < 0 and !CurrentRun.world.current_level_info.track_cells.has(cell):
				BetterTerrain.set_cell(self, 0, cell, 1)
			elif !CurrentRun.world.current_level_info.track_cells.has(cell):
				var terrain = round(3 * (alt+level_terrain) / 20)
				BetterTerrain.set_cell(self, 0, cell, terrain)
			if coords not in loaded_chunks:
				loaded_chunks.append(coords)
			new_cells.append(cell)
	
	return new_cells

func set_track_cell(pos):
	var coords = local_to_map(pos)
	BetterTerrain.set_cell(self, 0, coords, 1)
	CurrentRun.world.current_level_info.track_cells.append(coords)
	for c in get_surrounding_cells(coords):
		if !CurrentRun.world.current_level_info.track_cells.has(c):
			CurrentRun.world.current_level_info.track_cells.append(c)
			BetterTerrain.set_cell(self, 0, c, 1)
			for cc in get_surrounding_cells(c):
				if !CurrentRun.world.current_level_info.track_cells.has(cc):
					CurrentRun.world.current_level_info.track_cells.append(cc)
					BetterTerrain.set_cell(self, 0, cc, 1)

func edge_reached(direction, body, entered_map):
	if body.is_in_group("player"):
		match direction:
			"left":
				if !CurrentRun.world.current_level_info.map_positions.has(entered_map.global_position + Vector2(-32*128,0)):
					spawn_chunk(entered_map.global_position + Vector2(-32*128,0))
			"bottom":
				if !CurrentRun.world.current_level_info.map_positions.has(entered_map.global_position + Vector2(0,32*128)):
					spawn_chunk(entered_map.global_position + Vector2(0,32*128))
			"right":
				if !CurrentRun.world.current_level_info.map_positions.has(entered_map.global_position + Vector2(32*128,0)):
					spawn_chunk(entered_map.global_position + Vector2(32*128,0))
			"top":
				if !CurrentRun.world.current_level_info.map_positions.has(entered_map.global_position + Vector2(0,-32*128)):
					spawn_chunk(entered_map.global_position + Vector2(0,-32*128))
