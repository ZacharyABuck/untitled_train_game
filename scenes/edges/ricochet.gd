extends Edge

func handle_level_up():
	update_player_info()

func update_player_info():
	CurrentRun.world.current_player_info.ricochet_amount += 1
	print("Updated ricochet amount: ", str(CurrentRun.world.current_player_info.ricochet_amount))
