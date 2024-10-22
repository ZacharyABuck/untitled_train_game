extends Edge
# 20% increased move speed
var move_speed_multiplier: float = 1.2

func _ready():
	CurrentRun.world.current_player_info.current_movespeed = CurrentRun.world.current_player_info.base_movespeed
	super()

func handle_level_up():
	update_player_info()

func update_player_info():
	CurrentRun.world.current_player_info.current_movespeed *= move_speed_multiplier
	print("Updated player move speed modifier: ", CurrentRun.world.current_player_info.current_movespeed)
