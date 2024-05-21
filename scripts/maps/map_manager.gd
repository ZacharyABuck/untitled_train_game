extends Node2D

var map = preload("res://scenes/map.tscn")

var altitude = FastNoiseLite.new()

var tile_atlas_coords = [Vector2i(2,1), Vector2i(9,6), Vector2i(9,1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	altitude.frequency = .1
	altitude.seed = randi()
	spawn_map(Vector2(0,0))
	

func spawn_map(pos):
	var new_map = map.instantiate()
	new_map.global_position = pos
	LevelInfo.map_positions.append(pos)
	call_deferred("add_child", new_map)
	for i in new_map.get_used_cells(0):
		var alt = altitude.get_noise_2d(pos.x - (new_map.get_used_rect().size.x / 2) + i.x, pos.y - (new_map.get_used_rect().size.y / 2) + i.y) * 10
		if alt < 0:
			new_map.set_cell(0, i, 1, Vector2(2,0), 0)
		else:
			new_map.set_cell(0, i, 1, Vector2(round(3 * (alt+3) / 20), 0), 0)
	LevelInfo.active_map = new_map
	new_map.edge_reached.connect(edge_reached)
	print("Map Spawned:" + str(new_map))

func edge_reached(direction, body, entered_map):
	if body.is_in_group("player"):
		match direction:
			"left":
				if !LevelInfo.map_positions.has(entered_map.global_position + Vector2(-32*128,0)):
					spawn_map(entered_map.global_position + Vector2(-32*128,0))
			"bottom":
				if !LevelInfo.map_positions.has(entered_map.global_position + Vector2(0,32*128)):
					spawn_map(entered_map.global_position + Vector2(0,32*128))
			"right":
				if !LevelInfo.map_positions.has(entered_map.global_position + Vector2(32*128,0)):
					spawn_map(entered_map.global_position + Vector2(32*128,0))
			"top":
				if !LevelInfo.map_positions.has(entered_map.global_position + Vector2(0,-32*128)):
					spawn_map(entered_map.global_position + Vector2(0,-32*128))
