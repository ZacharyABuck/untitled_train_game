extends Node2D

func check_for_edges():
	for edge in EdgeInfo.edge_inventory.keys():
		respawn_edge(edge)
		if EdgeInfo.edge_roster[edge]["update"] == true:
			for level in range(1, EdgeInfo.edge_inventory[edge]["level"]):
				var new_level = _increase_edge_level(EdgeInfo.edge_inventory[edge]["scene"])
				if new_level == EdgeInfo.edge_inventory[edge]["level"]:
					break

func respawn_edge(edge):
	var edge_scene = EdgeInfo.edge_roster[edge]["scene"].instantiate()
	add_child(edge_scene)
	EdgeInfo.edge_inventory[edge]["scene"] = edge_scene

func add_edge(edge_reference):
	# loop through all Child Edges to see if one already exists.
	# if it does exist, increase its level. Otherwise, add new Edge.
	var existing_edge
	var existing_edge_found = false
	for child_edge in get_children():
		if child_edge.edge_name == EdgeInfo.edge_roster[edge_reference]["name"]:
			existing_edge = child_edge
			existing_edge_found = true
	if existing_edge_found:
		var level = _increase_edge_level(existing_edge)
		EdgeInfo.edge_inventory[edge_reference]["level"] = level
	else:
		var edge_scene = EdgeInfo.edge_roster[edge_reference]["scene"].instantiate()
		add_child(edge_scene)
		edge_scene.update_player_info()
		EdgeInfo.edge_inventory[edge_reference] = {"scene" = edge_scene, "level" = 1}

func _increase_edge_level(edge : Edge):
	edge.edge_level += 1
	edge.handle_level_up()
	return edge.edge_level
