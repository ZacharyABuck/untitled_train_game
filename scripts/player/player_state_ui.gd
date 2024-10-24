extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("lasso") or event.is_action_pressed("interact"):
		CurrentRun.world.current_level_info.active_level.close_all_ui()
		CurrentRun.world.current_player_info.state = "default"
