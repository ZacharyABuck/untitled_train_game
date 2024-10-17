extends CanvasLayer

@onready var margin_container = $MarginContainer
@onready var path_label = $MarginContainer/VBoxContainer/PathLabel
@onready var mission_complete_container = $MarginContainer/VBoxContainer/MissionCompleteContainer
@onready var return_button = $MarginContainer/VBoxContainer/ReturnButton
@onready var no_missions_label = $MarginContainer/VBoxContainer/NoMissionsLabel
@onready var level_up_bar = $MarginContainer/VBoxContainer/HBoxContainer/LevelUpBar
@onready var edge_menu = $MarginContainer/EdgeMenu

var edge_panel = preload("res://scenes/edges/edge_panel.tscn")

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")

func _ready():
	hide()
	return_button.hide()
	no_missions_label.hide()

func fade_in():
	margin_container.position.y = -1000
	show()

	var pos_tween = create_tween()
	pos_tween.tween_property(margin_container, "position", Vector2(0,0), 1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await pos_tween.finished
	
	await xp_sequence_begin()
	
	return_button.show()

func show_no_missions_label():
	no_missions_label.show()

func set_path_label():
	var starting_town = CurrentRun.world.current_world_info.active_town
	var ending_town = CurrentRun.world.current_level_info.destination
	path_label.text = starting_town + " to " + ending_town

func spawn_reward_panel(mission_success, sprite, reward):
	var new_panel = mission_reward_panel.instantiate()
	mission_complete_container.add_child(new_panel)
	new_panel.populate(mission_success, sprite, reward)

func _on_return_button_pressed():
	AudioSystem.play_audio("basic_button_click", -10)
	hide()
	return_button.hide()
	no_missions_label.hide()

func xp_sequence_begin():
	var player_info = CurrentRun.world.current_player_info
	level_up_bar.max_value = player_info.next_level_experience
	level_up_bar.value = player_info.current_experience
	level_up_bar.show()
	var old_level = player_info.current_level
	
	player_info.end_of_route_xp()
	await get_tree().create_timer(.5).timeout
	
	if player_info.current_level > old_level:
		var fill_tween = create_tween()
		fill_tween.tween_property(level_up_bar, "value", level_up_bar.max_value, 3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await fill_tween.finished
		level_up_bar.max_value = player_info.next_level_experience
		level_up_bar.value = 0
		
		level_up_sequence()
		
		var fill_tween_2 = create_tween()
		fill_tween_2.tween_property(level_up_bar, "value", player_info.current_experience, 2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		await fill_tween_2.finished
		return true
		
	else:
		var fill_tween = create_tween()
		fill_tween.tween_property(level_up_bar, "value", player_info.current_experience, 3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		await fill_tween.finished
		return true
	
func level_up_sequence():
	populate_edge_menu()
	edge_menu.show()

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
	#unpause_game()
	CurrentRun.world.current_player_info.state = "default"

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