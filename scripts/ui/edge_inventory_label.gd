extends TextureRect



func populate(edge_reference):
	texture = EdgeInfo.edge_roster[edge_reference]["sprite"]
	$RichTextLabel.text = str(EdgeInfo.edge_roster[edge_reference]["name"] + "\n Level: " + str(CurrentRun.world.current_edge_info.edge_inventory[edge_reference]["level"]))


func _on_mouse_entered():
	$RichTextLabel.show()


func _on_mouse_exited():
	$RichTextLabel.hide()
