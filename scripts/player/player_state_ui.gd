extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("strike"):
		LevelInfo.active_level.close_all_ui()
		PlayerInfo.state = "default"
