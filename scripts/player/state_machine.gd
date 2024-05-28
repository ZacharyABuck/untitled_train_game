extends Node2D
class_name StateMachine

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in get_children():
		if i.name == owner.state:
			i.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			i.process_mode = Node.PROCESS_MODE_DISABLED
