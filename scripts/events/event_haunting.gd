extends Event

var alert_text: String = "Haunting!"

var spawn_count: int = 10

func trigger_haunting(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		event_triggered()
		print("Event Triggered: Haunting")
		set_alert_text_and_play(alert_text)
		LevelInfo.active_level.instant_night()
		spawn_ghosts()
		$NightTimer.start()

func spawn_ghosts():
	var spawner = EnemySpawner.new()
	spawner.spawn_enemy(spawn_count, "ghost", null)

func _on_night_timer_timeout():
	LevelInfo.active_level.instant_day()
	event_finished()
