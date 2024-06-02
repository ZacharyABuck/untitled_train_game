extends Area2D
class_name EventArea

var event_index
var type

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_collision_shape()
	set_collision_layers()
	spawn_event(type)

func spawn_collision_shape():
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = load("res://shapes/shape_event_trigger.tres")
	add_child(collision_shape)
	collision_shape.debug_color = Color(1,0,0,.5)

func set_collision_layers():
	set_collision_layer_value(8, true)
	set_collision_mask_value(2, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	monitoring = true
	monitorable = true

func spawn_event(event_type):
	await get_tree().create_timer(.5).timeout
	var new_event = LevelInfo.events_roster[event_type]["scene"].instantiate()
	for i in get_overlapping_areas():
		if i.get_collision_layer_value(2) == true:
			new_event.global_position = i.global_position
			new_event.type = event_type
			break
	LevelInfo.active_level.call_deferred("add_child", new_event)
	call_deferred("queue_free")
