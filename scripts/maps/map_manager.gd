extends Node2D

var map = preload("res://scenes/map.tscn")

var tile_atlas_coords = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0)]

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_map(Vector2(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_map(pos):
	var new_map = map.instantiate()
	new_map.global_position = pos
	LevelInfo.map_positions.append(pos)
	call_deferred("add_child", new_map)
	for i in new_map.get_used_cells(0):
		new_map.set_cell(0, i, 0, tile_atlas_coords.pick_random(), 0)
	LevelInfo.active_map = new_map
	new_map.edge_reached.connect(edge_reached)
	print("Map Spawned:" + str(new_map))

func edge_reached(direction, body):
	if body.is_in_group("player"):
		match direction:
			"left":
				if !LevelInfo.map_positions.has(LevelInfo.active_map.global_position + Vector2(-32*128,0)):
					spawn_map(LevelInfo.active_map.global_position + Vector2(-32*128,0))
			"bottom":
				if !LevelInfo.map_positions.has(LevelInfo.active_map.global_position + Vector2(0,32*128)):
					spawn_map(LevelInfo.active_map.global_position + Vector2(0,32*128))
			"right":
				if !LevelInfo.map_positions.has(LevelInfo.active_map.global_position + Vector2(32*128,0)):
					spawn_map(LevelInfo.active_map.global_position + Vector2(32*128,0))
			"top":
				if !LevelInfo.map_positions.has(LevelInfo.active_map.global_position + Vector2(0,-32*128)):
					spawn_map(LevelInfo.active_map.global_position + Vector2(0,-32*128))
