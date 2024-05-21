@tool
extends Line2D

@export var crosstie_distance := 10.0 : set = set_crosstie_distance

@onready var _crosstie_mesh_instance : MeshInstance2D = $Crosstie
@onready var _crosstie_multimesh : MultiMeshInstance2D = $MultiMeshInstance2D
@onready var track : Track = get_parent()

func _on_track_points_changed() -> void:
	points = track.curve_points
	_update_crossties()
	
func _update_crossties() -> void:
	
	if !_crosstie_multimesh:
		return
	
	var crossties = _crosstie_multimesh.multimesh
	crossties.mesh = _crosstie_mesh_instance.mesh
	
	var curve_length = track.curve.get_baked_length()
	var crosstie_count = round(curve_length / crosstie_distance)
	crossties.instance_count = crosstie_count
	
	for i in range(crosstie_count):
		var t = Transform2D()
		var crosstie_position = track.curve.sample_baked((i * crosstie_distance) + crosstie_distance / 2.0)
		var next_position = track.curve.sample_baked((i + 1) * crosstie_distance)
		t = t.rotated((next_position - crosstie_position).normalized().angle())
		t.origin = crosstie_position
		crossties.set_instance_transform_2d(i, t)
		if not Engine.is_editor_hint():
			generate_collision_area(i, crossties)

func generate_collision_area(i, crossties):
	var area = Area2D.new()
	add_child(area)
	var collision_shape = CollisionShape2D.new()
	area.add_child(collision_shape)
	area.set_collision_layer_value(2, true)
	area.set_collision_mask_value(7, true)
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	area.monitoring = true
	area.monitorable = true
	area.global_transform = _crosstie_multimesh.global_transform * crossties.get_instance_transform_2d(i)
	collision_shape.shape = RectangleShape2D.new()
	var coords = LevelInfo.active_map.local_to_map(area.global_position)
	LevelInfo.active_map.set_cell(1, coords, 1, Vector2i(2,0), 0)
	LevelInfo.track_cells.append(coords)
	for c in LevelInfo.active_map.get_surrounding_cells(coords):
		if !LevelInfo.track_cells.has(c):
			LevelInfo.track_cells.append(c)
			LevelInfo.active_map.set_cell(1, c, 1, Vector2i(2,0), 0)

func set_crosstie_distance(new_dist: float) -> void:
	crosstie_distance = new_dist
	_update_crossties()
