extends ProgressBar


func _process(delta):
	if value < max_value:
		value += CurrentRun.world.current_player_info.current_charge_recovery_rate*delta
	if value >= max_value:
		CurrentRun.root.tutorial_ui.trigger_tutorial("charge_attack")
