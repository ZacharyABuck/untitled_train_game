extends Node

@onready var Player = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# level-up specific Edge (should just be GAIN an Edge -- it'll level it up if it already exists)
# loop through Edges and apply their stats to Player.
# add Edge as child. (takes an Edge from Roster as parameter)


func add_edge(edge_reference):

	# loop through all Child Edges to see if one already exists.
	# if it does exist, increase its level. Otherwise, add new Edge.
	var existing_edge
	var existing_edge_found = false
	for child_edge in self.get_children():
		if child_edge.edge_name == edge_reference:
			print("Matching Edge found: ", child_edge.edge_name)
			existing_edge = child_edge
			existing_edge_found = true
	if existing_edge_found:
		_increase_edge_level(existing_edge)
		print(existing_edge.edge_name, " is now level ", existing_edge.edge_level)
	else:
		print("Edge to load: ",EdgeInfo.edge_roster[edge_reference]["scene"] )
		var edge_scene = EdgeInfo.edge_roster[edge_reference]["scene"].instantiate()
		add_child(edge_scene)
		print("New Edge added: ", edge_scene.edge_name)

func _increase_edge_level(edge : Edge):
	edge.edge_level += 1
	edge.handle_level_up()


#var new_enemy = EnemyInfo.enemy_roster[type]["scene"].instantiate()

	#
	#if is_instance_valid(edge):
		#print("hit is instance valid")
		#edge.edge_level += 1
		#edge.handle_level_up()
		#print("New Edge level = ", edge.edge_level)
	#else:
		#print("hit ELSE in handle level-up in levle")
		#var edge_scene = load("res://scenes/edges/fan_the_hammer.tscn")
		#edge = edge_scene.instantiate()
		#new_player.receive_edge(edge)
	#new_player.refresh_current_ranged_weapon_stats()
