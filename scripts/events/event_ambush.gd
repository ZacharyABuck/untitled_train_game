extends Event

var alert_text: String = "Ambush!"

func ambush_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		print("Event Triggered: Ambush")
		TrainInfo.train_engine.brake_force = 5
		set_alert_text_and_play(alert_text)
		var new_spawner = EnemySpawner.new()
		LevelInfo.active_level.add_child(new_spawner)
		new_spawner.spawn_enemy(5, "bandit", null)
