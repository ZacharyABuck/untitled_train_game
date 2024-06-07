extends Area2D
class_name Event

var triggered: bool = false
var type: String
var difficulty

func _ready():
	triggered = false

#triggers when train enters the area. Specific event code is handled on the specific event scenes, e.g. event_ambush.gd
func event_triggered():
	CurrentRun.world.current_train_info.train_engine.train_whistle_sfx.play()
	triggered = true
	CurrentRun.world.current_level_info.active_level.in_event = true
	difficulty = CurrentRun.world.current_level_info.difficulty

func set_alert_text_and_play(text):
	var label = CurrentRun.world.current_level_info.active_level.alert_label
	label.text = text
	label.get_child(0).play("alert_flash")
	label.show()

func event_finished():
	CurrentRun.world.current_level_info.active_level.in_event = false
	CurrentRun.world.current_level_info.active_level.alert_label.hide()
	CurrentRun.world.current_train_info.train_engine.brake_force = 0
