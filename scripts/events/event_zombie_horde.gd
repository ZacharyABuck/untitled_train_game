extends Event

var alert_text: String = "Zombie Horde!"

func zombie_horde_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		print("Event Triggered: Zombie Horde")
		for i in $Zombies.get_children():
			i.target = PlayerInfo.active_player
			i.state = "moving"
			i.call_deferred("reparent", LevelInfo.active_level.enemies)
		set_alert_text_and_play(alert_text)
