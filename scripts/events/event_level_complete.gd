extends Event

var alert_text: String = "Arrived at " + CurrentRun.world.current_level_info.destination

func level_complete(area):
	if triggered == false:
		triggered = true
		event_triggered()
		set_alert_text_and_play(alert_text)
		
		await get_tree().create_timer(2).timeout
		
		CurrentRun.world.level_complete()
		
