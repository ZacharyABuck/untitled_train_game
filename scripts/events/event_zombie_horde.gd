extends Event

var alert_text: String = "Zombie Horde!"

var zombie = preload("res://scenes/enemies/enemy_zombie.tscn")

var zombies_spawned: bool = false

#spawn more zombies if difficulty increases
func outer_area_entered(area):
	if area.get_parent().is_in_group("car") and zombies_spawned == false:
		zombies_spawned = true
		
		#add new zombies based on current difficulty
		var new_zombie_count = round(LevelInfo.difficulty*.3)

		for z in new_zombie_count:
			var new_zombie = zombie.instantiate()
			$Zombies.call_deferred("add_child", new_zombie)
			new_zombie.global_position = global_position + Vector2(randi_range(-500,500), randi_range(-500,500))
			new_zombie.state = "idle"

#trigger zombies into action
func zombie_horde_triggered(area):
	if area.get_parent().is_in_group("car") and triggered == false:
		event_triggered()
		print("Event Triggered: Zombie Horde")
		
		#move and reparent zombies
		for i in $Zombies.get_children():
			i.target = PlayerInfo.active_player
			i.state = "moving"
			i.call_deferred("reparent", LevelInfo.active_level.enemies)
		set_alert_text_and_play(alert_text)
