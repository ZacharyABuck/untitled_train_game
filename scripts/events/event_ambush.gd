extends Event

var alert_text: String = "Ambush!"
var starting_spawn_amount: int = 2

func ambush_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		event_triggered()
		print("Event Triggered: Ambush")
		TrainInfo.train_engine.brake_force = 5
		set_alert_text_and_play(alert_text)
		var new_spawner = EnemySpawner.new()
		LevelInfo.active_level.add_child(new_spawner)
		new_spawner.spawn_enemy(round(starting_spawn_amount+(difficulty*.5)), "bandit", null)
