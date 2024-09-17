extends Edge

func handle_level_up():
	update_player_info()

func update_player_info():
	CurrentRun.world.current_player_info.current_repair_rate *= 1.2
	print("Updated repair rate: ", str(CurrentRun.world.current_player_info.current_repair_rate))
