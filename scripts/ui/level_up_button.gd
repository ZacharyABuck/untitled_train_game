extends TextureButton

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		LevelInfo.active_level.level_up_button_pressed()
		PlayerInfo.state = "ui_edge_selection"
