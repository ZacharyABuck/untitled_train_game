extends Edge

func handle_level_up():
	update_player_info()

func update_player_info():
	CurrentRun.world.current_player_info.current_armor += 1
	CurrentRun.world.current_player_info.active_player.health_component.ARMOR_VALUE = CurrentRun.world.current_player_info.current_armor
	print("ARMOR: " + str(CurrentRun.world.current_player_info.active_player.health_component.ARMOR_VALUE))
