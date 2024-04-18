extends Area2D
class_name Event

var triggered: bool = false
var type: String

func _ready():
	triggered = false
	area_entered.connect(event_triggered)

#triggers when train enters the area. Specific event code is handled on the specific event scenes, e.g. event_ambush.gd
func event_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		triggered = true
		LevelInfo.active_level.in_event = true

func set_alert_text_and_play(text):
	var label = LevelInfo.active_level.alert_label
	label.text = text
	label.get_child(0).play("alert_flash")
	label.show()

func event_finished():
	LevelInfo.active_level.in_event = false
	LevelInfo.active_level.alert_label.hide()
	TrainInfo.train_engine.brake_force = 0
