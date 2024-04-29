extends Event

var alert_text: String = "Shop"

func _ready():
	await get_tree().create_timer(.5).timeout
	if $Sprite2D/TrackDetector.is_colliding():
		if $Sprite2D/TrackDetector.get_collider().get_collision_layer_value(2) == true:
			$Sprite2D.global_position.x += 300

func shop_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		event_triggered()
		print("Event Triggered: Shop")
		set_alert_text_and_play(alert_text)
		TrainInfo.train_engine.brake_force = 0
		$Sprite2D/EnterButton.show()

func _on_enter_button_pressed():
	$Sprite2D/EnterButton.hide()
	LevelInfo.active_level.ui_open = true
	LevelInfo.root.pause_game()
	$CanvasLayer.show()

func _on_leave_button_pressed():
	LevelInfo.root.unpause_game()
	LevelInfo.active_level.ui_open = false
	$CanvasLayer.hide()
	event_finished()

