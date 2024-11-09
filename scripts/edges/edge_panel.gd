extends Control

var edge = null
signal clicked
var edge_chosen: bool = false
var is_being_replaced: bool = false

func _ready():
	scale = Vector2.ZERO
	show()
	$AnimationPlayer.play("pop in")
	trigger_shuffle()

# -- FILL IN EDGE INFORMATION -- #
func set_info(new_edge):
	edge = new_edge

func populate(new_edge):
	var style_box_texture = StyleBoxTexture.new()
	style_box_texture.texture = EdgeInfo.edge_roster[new_edge]["sprite"]
	$BG.add_theme_stylebox_override("panel", style_box_texture)
	$DescriptionLabel.text = "[center]" + EdgeInfo.edge_roster[new_edge]["description"] + "[/center]"
	
	if CurrentRun.world.current_edge_info.edge_inventory.has(new_edge):
		$NextLevelInfo/LevelLabel.text = "[center]Level " + str(CurrentRun.world.current_edge_info.edge_inventory[new_edge]["level"]) +\
										" -> Level " + str(CurrentRun.world.current_edge_info.edge_inventory[new_edge]["level"] + 1)
	else:
		$NextLevelInfo/LevelLabel.text = ""

func trigger_shuffle():
	var total_timer = Timer.new()
	add_child(total_timer)
	total_timer.wait_time = 1.0
	total_timer.one_shot = true
	total_timer.start()
	
	var shuffle_timer = Timer.new()
	add_child(shuffle_timer)
	shuffle_timer.wait_time = .05
	shuffle_timer.start()
	
	while !total_timer.is_stopped():
		await shuffle_timer.timeout
		var random_edge = EdgeInfo.edge_roster.keys().pick_random()
		populate(random_edge)
		shuffle_timer.start()
	
	populate(edge)
	$AnimationPlayer.play("small_pop")
	AudioSystem.play_audio("page_turn", -10)

# -- REACT TO MOUSE HOVER -- #
func _on_mouse_entered():
	if edge_chosen == false:
		$HoverSFX.play()
		var shadow_tween = get_tree().create_tween()
		shadow_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		shadow_tween.tween_property($Shadow, "scale", Vector2(1.01, 1.01), .1).set_ease(Tween.EASE_IN)
		if is_being_replaced:
			$NextLevelInfo.get_child(0).text = "[center]Remove[/center]"
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
			if "edge_chosen" in i:
				i.edge_chosen = true
		$CloseSFX.play()
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(self, "scale", Vector2(1.05, 1.05), .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		await tween.finished
		clicked.emit(edge, is_being_replaced)
