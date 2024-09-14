extends CanvasLayer

@onready var edge_container = $MarginContainer/GridContainer/EdgeContainer
@onready var world = $".."



# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for edge in EdgeInfo.edge_roster:
		#set edge name
		var hbox = edge_container.get_child(index)
		hbox.get_child(0).text = edge
		
		#set edge level
		hbox.get_child(1).text = "0"
		
		#connect button
		hbox.get_child(2).pressed.connect(level_up_edge.bind(edge))
		
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("Debug Menu"):
		if visible:
			world.unpause_game()
			hide()
		else:
			world.pause_game()
			show()

func level_up_edge(edge_reference):
	if world.current_player_info.active_player != null:
		var player = world.current_player_info.active_player
		player.edge_handler.add_edge(edge_reference)
	else:
		print("no player")

func refresh_labels():
	await get_tree().create_timer(.5).timeout
	for hbox in edge_container.get_children():
		if world.current_edge_info.edge_inventory.has(hbox.get_child(0).text):
			hbox.get_child(1).text = str(world.current_edge_info.edge_inventory[hbox.get_child(0).text]["level"])
