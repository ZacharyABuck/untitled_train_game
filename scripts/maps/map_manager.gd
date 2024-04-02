extends Node2D

var map = preload("res://scenes/map.tscn")

var tile_atlas_coords = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0)]

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map(Vector2(0,0))
	generate_map(Vector2(0,1536))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#for i in get_children():
		#i.global_position.y += TrainInfo.speed*delta
		#if i.top_marker != null and i.top_marker.global_position.y >= 0:
			#i.top_marker.queue_free()
			#generate_map(i.spawn_marker.global_position)
		#if i.despawn_marker.global_position.y >= 0:
			#i.queue_free()

func generate_map(pos):
	var new_map = map.instantiate()
	new_map.global_position = pos
	add_child(new_map)
	for i in new_map.get_used_cells(0):
		new_map.set_cell(0, i, 0, tile_atlas_coords.pick_random(), 0)
