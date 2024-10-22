extends Edge

var distance_increase_amount: float = .2

func _ready():
	handle_level_up()
	super()

func handle_level_up():
	var lasso = CurrentRun.world.current_player_info.active_player.lasso
	lasso.max_distance += (lasso.max_distance * distance_increase_amount)
	print("Max Lasso Distance: " + str(lasso.max_distance))
