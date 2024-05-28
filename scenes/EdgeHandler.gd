extends Node

func add_edge(edge_reference):
	# loop through all Child Edges to see if one already exists.
	# if it does exist, increase its level. Otherwise, add new Edge.
	var existing_edge
	var existing_edge_found = false
	for child_edge in self.get_children():
		if child_edge.edge_name == edge_reference["name"]:
			existing_edge = child_edge
			existing_edge_found = true
	if existing_edge_found:
		_increase_edge_level(existing_edge)
	else:
		var edge_scene = edge_reference["scene"].instantiate()
		add_child(edge_scene)

func _increase_edge_level(edge : Edge):
	edge.edge_level += 1
	edge.handle_level_up()
