extends TextureButton

func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		CurrentRun.world.current_level_info.active_level.level_up_button_pressed()
		CurrentRun.world.current_player_info.state = "ui_edge_selection"
