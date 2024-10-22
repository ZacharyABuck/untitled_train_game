extends CanvasLayer

@onready var margin_container = $MarginContainer
@onready var path_label = $MarginContainer/VBoxContainer/PathLabel
@onready var mission_complete_container = $MarginContainer/VBoxContainer/MissionCompleteContainer
@onready var return_button = $MarginContainer/VBoxContainer/ReturnButton
@onready var no_missions_label = $MarginContainer/VBoxContainer/NoMissionsLabel

@onready var level_up_bar = $MarginContainer/VBoxContainer/HBoxContainer/LevelUpBar
@onready var level_min_label = $MarginContainer/VBoxContainer/HBoxContainer/LevelMinLabel
@onready var level_max_label = $MarginContainer/VBoxContainer/HBoxContainer/LevelMaxLabel

@onready var edge_menu = $EdgeMenu

var edge_panel = preload("res://scenes/edges/edge_panel.tscn")

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")



func _ready():
	hide()
	return_button.hide()
	no_missions_label.hide()
	level_up_bar.hide()
	level_max_label.hide()
	level_min_label.hide()

func fade_in():
	margin_container.position.y = -1000
	
	set_path_label()
	set_level_labels()
	
	CurrentRun.world.world_map.process_mode = PROCESS_MODE_DISABLED
	
	show()

	var pos_tween = create_tween()
	pos_tween.tween_property(margin_container, "position", Vector2(0,0), 1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await pos_tween.finished
	
	level_up_sequence()

func show_no_missions_label():
	no_missions_label.show()

func set_path_label():
	var starting_town = CurrentRun.world.current_world_info.last_route[0]
	var ending_town = CurrentRun.world.current_world_info.last_route[1]
	path_label.text = starting_town + " to " + ending_town

func set_level_labels():
	level_min_label.text = "Level " + str(CurrentRun.world.current_player_info.current_level)
	level_max_label.text = "Level " + str(CurrentRun.world.current_player_info.current_level + 1)

func spawn_reward_panel(mission_success, sprite, reward):
	var new_panel = mission_reward_panel.instantiate()
	mission_complete_container.add_child(new_panel)
	new_panel.populate(mission_success, sprite, reward)

func _on_return_button_pressed():
	CurrentRun.world.world_map.process_mode = PROCESS_MODE_INHERIT
	CurrentRun.world.camera.jump_to_player()
	AudioSystem.play_audio("basic_button_click", -10)
	hide()
	return_button.hide()
	no_missions_label.hide()

#func xp_sequence_begin():
	#var player_info = CurrentRun.world.current_player_info
#
	#level_up_bar.show()
#
	#player_info.end_of_route_xp()
	#await get_tree().create_timer(.5).timeout
	#
	#check_for_level()
#
#func check_for_level():
	#var player_info = CurrentRun.world.current_player_info
	#if player_info.has_leveled_up():
		#await fill_xp_bar(level_up_bar.max_value)
		#level_up_bar.max_value = player_info.next_level_experience
		#level_up_bar.min_value = 0
		#level_up_bar.value = 0
		#set_level_labels()
		#level_up_sequence()
		#
	#else:
		#await fill_xp_bar(player_info.current_experience)
		#return_button.show()
	#
#func fill_xp_bar(value):
	#var fill_tween = create_tween()
	#fill_tween.tween_property(level_up_bar, "value", value, 3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#await fill_tween.finished
	#return true

func level_up_sequence():
	populate_edge_menu()
	edge_menu.show()
	animate_edge_menu()


# Edge Menu
func populate_edge_menu():
	var chosen_edges: Array = []
	for i in 3:
		var new_panel = edge_panel.instantiate()
		edge_menu.add_child(new_panel)
		
		var random_edge = EdgeInfo.edge_roster.keys().pick_random()
		while chosen_edges.has(random_edge):
			random_edge = EdgeInfo.edge_roster.keys().pick_random()
		
		chosen_edges.append(random_edge)
		new_panel.populate(random_edge)
		new_panel.clicked.connect(edge_selected)
		new_panel.hide()

func animate_edge_menu():
	var index = 1
	var increment = (get_viewport().size.x*.75)/edge_menu.get_child_count()
	for edge in edge_menu.get_children():
		var end_pos = Vector2(increment*index, get_viewport().size.y*.5)
		edge.top_level = true
		edge.global_position = Vector2(-500, get_viewport().size.y*.5)
		edge.show()
		var pos_tween = create_tween()
		pos_tween.tween_property(edge, "global_position", end_pos, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		index += 1

func edge_selected(edge):
	add_edge(edge)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(edge_menu, "modulate", Color.TRANSPARENT, .2)
	await tween.finished
	edge_menu.hide()
	for i in edge_menu.get_children():
		i.queue_free()
	edge_menu.modulate = Color.WHITE

	return_button.show()
	#check_for_level()

func add_edge(edge_reference):
	var existing_edge_found = false
	for edge in CurrentRun.world.current_edge_info.edge_inventory.keys():
		if edge == edge_reference:
			existing_edge_found = true
	if existing_edge_found:
		CurrentRun.world.current_edge_info.edge_inventory[edge_reference]["level"] += 1
	else:
		CurrentRun.world.current_edge_info.edge_inventory[edge_reference] = {"scene" = null, "level" = 1}
		
	CurrentRun.world.debug_ui.refresh_labels()
	CurrentRun.world.world_ui.refresh_edges()
