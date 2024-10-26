extends Edge

var increment: float = 1.0

func _ready():
	super()
	
	CurrentRun.world.current_player_info.global_sell_modifier = increment

func handle_level_up():
	CurrentRun.world.current_player_info.global_sell_modifier += increment
