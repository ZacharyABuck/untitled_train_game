extends Label

func _process(_delta):
	text = "Money: $" + str("%.2f" % CurrentRun.world.current_player_info.current_money)
