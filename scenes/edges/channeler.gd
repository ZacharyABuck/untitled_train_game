extends Edge

var increase_amount: float = 1.0

func _ready():
	super()
	
	CurrentRun.world.current_player_info.global_shock_time = 0
	handle_level_up()

func handle_level_up():
	CurrentRun.world.current_player_info.global_shock_time += increase_amount
