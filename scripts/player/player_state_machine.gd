extends StateMachine

func _process(_delta):
	for i in get_children():
		if i.name == CurrentRun.world.current_player_info.state:
			i.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			i.process_mode = Node.PROCESS_MODE_DISABLED
