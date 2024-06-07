extends Event

var alert_text: String = "Stampede!"

var herd_count: int = 75
var spawn_count: int = 0
var completed_count: int = 0

@onready var herd = $Herd
@onready var spawn_timer = $SpawnTimer

const COW = preload("res://scenes/events/cow.tscn")

@onready var start_pos = $StartPosition.global_position
@onready var end_pos = $EndPosition.global_position

func stampede_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		event_triggered()
		rotation_degrees = area.owner.global_rotation_degrees + 90
		start_pos = $StartPosition.global_position
		end_pos = $EndPosition.global_position
		print("Event Triggered: Stampede")
		set_alert_text_and_play(alert_text)
		CurrentRun.world.current_train_info.train_engine.brake_force = 5
		
		spawn_timer.start()

func _on_spawn_timer_timeout():
	var new_cow = COW.instantiate()
	herd.add_child(new_cow)
	var random_offset = Vector2(randi_range(-100,100),randi_range(-100,100))
	new_cow.global_position = start_pos + random_offset
	new_cow.target = end_pos + random_offset
	spawn_count += 1
	if spawn_count >= herd_count:
		spawn_timer.stop()

func _on_end_position_body_entered(body):
	if body.get_collision_layer_value(9) == true:
		body.queue_free()
		cow_completed()

func cow_completed():
	completed_count += 1
	if completed_count >= herd_count:
		event_finished()
