extends Control

var edge = null
signal clicked
var edge_chosen: bool = false

# -- FILL IN EDGE INFORMATION -- #
func populate(new_edge):
	edge = new_edge
	var style_box_texture = StyleBoxTexture.new()
	style_box_texture.texture = EdgeInfo.edge_roster[new_edge]["sprite"]
	$BG.add_theme_stylebox_override("panel", style_box_texture)
	$DescriptionLabel.text = "[center]" + EdgeInfo.edge_roster[new_edge]["description"] + "[/center]"
	
	if CurrentRun.world.current_edge_info.edge_inventory.has(new_edge):
		$NextLevelInfo/LevelLabel.text = "[center]Level " + str(CurrentRun.world.current_edge_info.edge_inventory[new_edge]["level"]) +\
										" -> Level " + str(CurrentRun.world.current_edge_info.edge_inventory[new_edge]["level"] + 1)
	else:
		$NextLevelInfo/LevelLabel.text = ""

# -- REACT TO MOUSE HOVER -- #
func _on_mouse_entered():
	if edge_chosen == false:
		$HoverSFX.play()
		var shadow_tween = get_tree().create_tween()
		shadow_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		shadow_tween.tween_property($Shadow, "scale", Vector2(1.01, 1.01), .1).set_ease(Tween.EASE_IN)
		$NextLevelInfo.show()

# -- REACT TO MOUSE EXITED -- #
func _on_mouse_exited():
	if edge_chosen == false:
		var shadow_tween = get_tree().create_tween()
		shadow_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		shadow_tween.tween_property($Shadow, "scale", Vector2(1, 1), .1).set_ease(Tween.EASE_IN)
		$NextLevelInfo.hide()

# -- WHEN CLICKED -- #
func _on_gui_input(event):
	if event.is_action_pressed("shoot") and edge_chosen == false:
		for i in get_parent().get_children():
			i.edge_chosen = true
		$CloseSFX.play()
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		await tween.finished
		clicked.emit(edge)
