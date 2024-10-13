extends Drop

func player_pickup_drop(v):
	print(v)
	CurrentRun.world.current_player_info.current_money += v
	print(CurrentRun.world.current_player_info.current_money)
