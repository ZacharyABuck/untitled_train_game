extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	owner.running_sfx.stop()
	owner.sprite.look_at(get_global_mouse_position())
	owner.sprite.play("standing")
	owner.repair()

func _unhandled_input(event):
	if event.is_action_released("repair"):
		CurrentRun.world.current_player_info.state = "default"
		CurrentRun.world.current_level_info.active_level.close_all_ui()
