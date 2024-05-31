extends Edge
# 20% increased move speed
var move_speed_multiplier: float = 1.2

func handle_level_up():
	update_player_info()

func update_player_info():
	PlayerInfo.current_movespeed *= move_speed_multiplier
	print("Updated player move speed modifier: ", PlayerInfo.current_movespeed)
