extends Control

var edge = null
signal clicked
var edge_chosen: bool = false

# -- FILL IN EDGE INFORMATION -- #
func populate(new_edge):
	edge = new_edge
	$BG/VBoxContainer/EdgeName.text = EdgeInfo.edge_roster[new_edge]["name"]
	$BG/VBoxContainer/EdgeIcon.texture = EdgeInfo.edge_roster[new_edge]["sprite"]
	$BG/VBoxContainer/MarginContainer/EdgeFlavor.text = EdgeInfo.edge_roster[new_edge]["flavor"]
	$BG/VBoxContainer/EdgeDescription.text = EdgeInfo.edge_roster[new_edge]["description"]

# -- REACT TO MOUSE HOVER -- #
func _on_mouse_entered():
	if edge_chosen == false:
		$HoverSFX.play()
		var bg = $BG
		var pos_tween = get_tree().create_tween()
		pos_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		pos_tween.tween_property(bg, "position", Vector2(bg.position.x-5, bg.position.y-5), .1).set_ease(Tween.EASE_IN)
		var shadow_tween = get_tree().create_tween()
		shadow_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		shadow_tween.tween_property($Shadow, "scale", Vector2(1.01, 1.01), .1).set_ease(Tween.EASE_IN)

# -- REACT TO MOUSE EXITED -- #
func _on_mouse_exited():
	if edge_chosen == false:
		var bg = $BG
		var pos_tween = get_tree().create_tween()
		pos_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		pos_tween.tween_property(bg, "position", Vector2(bg.position.x+5, bg.position.y+5), .1).set_ease(Tween.EASE_IN)
		var shadow_tween = get_tree().create_tween()
		shadow_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		shadow_tween.tween_property($Shadow, "scale", Vector2(1, 1), .1).set_ease(Tween.EASE_IN)

# -- WHEN CLICKED -- #
func _on_gui_input(event):
	if event.is_action_pressed("shoot") and edge_chosen == false:
		for i in get_parent().get_children():
			i.edge_chosen = true
		print(str(edge) + " selected")
		$CloseSFX.play()
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		await tween.finished
		clicked.emit(edge)
