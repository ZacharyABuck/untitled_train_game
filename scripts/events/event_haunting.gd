extends Event

var alert_text: String = "Haunting!"

var start_spawn_count: int = 1

func trigger_haunting(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		event_triggered()
		print("Event Triggered: Haunting")
		set_alert_text_and_play(alert_text)
		CurrentRun.world.current_level_info.active_level.instant_night()
		spawn_ghosts()
		$NightTimer.start()

func spawn_ghosts():
	var spawn_count = start_spawn_count + round(CurrentRun.world.current_level_info.difficulty*.3)
	var spawner = EnemySpawner.new()
	spawner.spawn_enemy(spawn_count, "ghost", null, false)

func _on_night_timer_timeout():
	CurrentRun.world.current_level_info.active_level.instant_day()
	event_finished()
