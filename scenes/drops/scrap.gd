extends Drop

func player_pickup_drop(v):
	CurrentRun.world.current_player_info.current_scrap += v
