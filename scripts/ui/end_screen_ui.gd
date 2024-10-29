extends CanvasLayer

@onready var panel_container = $PanelContainer
@onready var path_label = $PanelContainer/MarginContainer/VBoxContainer/PathLabel
@onready var mission_complete_container = $PanelContainer/MarginContainer/VBoxContainer/MissionCompleteContainer
@onready var return_button = $PanelContainer/MarginContainer/VBoxContainer/ReturnButton
@onready var no_missions_label = $PanelContainer/MarginContainer/VBoxContainer/NoMissionsLabel

@onready var level_up_bar = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LevelUpBar
@onready var level_min_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LevelMinLabel
@onready var level_max_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LevelMaxLabel

@onready var edge_menu = $EdgeMenu

@onready var animations = $AnimationPlayer

var edge_panel = preload("res://scenes/edges/edge_panel.tscn")

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")

func _ready():
	hide()
	animations.play("standby")
	return_button.hide()
	no_missions_label.hide()
	level_up_bar.hide()
	level_max_label.hide()
	level_min_label.hide()

func fade_in():
	set_path_label()
	set_level_labels()
	show()
	animations.play("slide_in")
	await animations.animation_finished
	level_up_sequence()
	
func show_no_missions_label():
	no_missions_label.show()

func set_path_label():
	var destination = CurrentRun.world.current_level_info.destination
	path_label.text = "Entering " + destination

func set_level_labels():
	level_min_label.text = "Level " + str(CurrentRun.world.current_player_info.current_level)
	level_max_label.text = "Level " + str(CurrentRun.world.current_player_info.current_level + 1)

func spawn_reward_panel(mission_success, mission):
	var new_panel = mission_reward_panel.instantiate()
	mission_complete_container.add_child(new_panel)
	new_panel.populate(mission_success, mission)

func _on_return_button_pressed():
	AudioSystem.play_audio("basic_button_click", -10)
	hide()
	animations.play("standby")
	return_button.hide()
	no_missions_label.hide()
	get_parent().unpause_game()

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

# Edge Menu
func populate_edge_menu():
	var chosen_edges: Array = []
	for i in 3:
		var new_panel = edge_panel.instantiate()
		new_panel.hide()
		edge_menu.add_child(new_panel)
		
		var random_edge = EdgeInfo.edge_roster.keys().pick_random()
		while chosen_edges.has(random_edge):
			random_edge = EdgeInfo.edge_roster.keys().pick_random()
		
		chosen_edges.append(random_edge)
		new_panel.populate(random_edge)
		new_panel.clicked.connect(edge_selected)

func edge_selected(edge):
	CurrentRun.world.current_player_info.active_player.edge_handler.add_edge(edge)
	#add_edge(edge)
	for i in edge_menu.get_children():
		i.queue_free()

	return_button.show()
#
#func add_edge(edge_reference):
	#var existing_edge_found = false
	#for edge in CurrentRun.world.current_edge_info.edge_inventory.keys():
		#if edge == edge_reference:
			#existing_edge_found = true
	#if existing_edge_found:
		#CurrentRun.world.current_edge_info.edge_inventory[edge_reference]["level"] += 1
	#else:
		#CurrentRun.world.current_edge_info.edge_inventory[edge_reference] = {"scene" = null, "level" = 1}
		#
	#CurrentRun.world.debug_ui.refresh_labels()
	#CurrentRun.world.world_ui.refresh_edges()
