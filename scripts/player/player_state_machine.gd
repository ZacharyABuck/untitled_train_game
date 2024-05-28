extends StateMachine

func _process(_delta):
	for i in get_children():
		if i.name == PlayerInfo.state:
			i.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			i.process_mode = Node.PROCESS_MODE_DISABLED
