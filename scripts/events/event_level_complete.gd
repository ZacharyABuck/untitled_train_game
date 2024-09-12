extends Event

var alert_text: String = "Arrived at " + CurrentRun.world.current_level_info.destination

func level_complete(area):
	if triggered == false:
		triggered = true
		event_triggered()
		set_alert_text_and_play(alert_text)
		
		await get_tree().create_timer(2).timeout
		
		CurrentRun.world.level_complete()
		


func _on_outer_area_area_entered(area):
	if area.get_parent().is_in_group("car"):
		#var direction = global_position.direction_to(area.global_position)
		look_at(area.get_parent().global_position)
