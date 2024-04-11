extends Area2D
class_name EventArea

var event_index
var type

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_collision_shape()
	set_collision_layers()
	area_entered.connect(on_area_entered)
	set_event()

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

func on_area_entered(area):
	pass

func set_event():
	match type:
		"ambush":
			spawn_ambush()

func spawn_ambush():
	await get_tree().create_timer(.5).timeout
	var new_event = load("res://scenes/events/event_ambush.tscn").instantiate()
	for i in get_overlapping_areas():
		if i.get_collision_layer_value(2) == true:
			new_event.global_position = i.global_position
			new_event.type = "ambush"
			break
	LevelInfo.root.call_deferred("add_child", new_event)
	call_deferred("queue_free")
