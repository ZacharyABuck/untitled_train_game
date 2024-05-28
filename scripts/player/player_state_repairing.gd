extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	owner.repair()

func _unhandled_input(event):
	if event.is_action_released("repair"):
		PlayerInfo.state = "default"
		LevelInfo.active_level.close_all_ui()
