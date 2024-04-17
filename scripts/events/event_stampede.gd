extends Event

var alert_text: String = "Stampede!"

var herd_count: int = 15
var spawn_count: int = 0
var completed_count: int = 0

@onready var herd = $Herd
@onready var spawn_timer = $SpawnTimer

const COW = preload("res://scenes/events/cow.tscn")

@onready var start_pos = $StartPosition.global_position
@onready var end_pos = $EndPosition.global_position

func stampede_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		print("start: " + str(start_pos), "end: " + str(end_pos))
		rotation_degrees = area.owner.global_rotation_degrees + 90
		start_pos = $StartPosition.global_position
		end_pos = $EndPosition.global_position
		triggered = true
		print("Event Triggered: Stampede")
		set_alert_text_and_play(alert_text)
		print("start: " + str(start_pos), "end: " + str(end_pos))
		TrainInfo.train_engine.brake_force = 5
		
		spawn_timer.start()

func _on_spawn_timer_timeout():
	var new_cow = COW.instantiate()
	herd.add_child(new_cow)
	new_cow.global_position = start_pos
	new_cow.target = end_pos
	print(global_position)
	new_cow.move_completed.connect(cow_completed)
	spawn_count += 1
	if spawn_count >= herd_count:
		spawn_timer.stop()

func cow_completed():
	completed_count += 1
	if completed_count >= herd_count:
		event_finished()
