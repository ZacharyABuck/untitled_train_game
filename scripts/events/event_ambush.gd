extends Event

var alert_text: String = "Ambush!"
var starting_spawn_amount: int = 2

func ambush_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		event_triggered()
		print("Event Triggered: Ambush")
		CurrentRun.world.current_train_info.train_engine.brake_force = 5
		set_alert_text_and_play(alert_text)
		var new_spawner = EnemySpawner.new()
		add_child(new_spawner)
		
		var random_spawn_point = CurrentRun.world.current_level_info.enemy_spawn_system.extra_spawns.get_children().pick_random().global_position
		print(random_spawn_point)
		new_spawner.spawn_enemy(round(starting_spawn_amount+(difficulty*.5)), "bandit", random_spawn_point)
