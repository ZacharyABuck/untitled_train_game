extends Node2D

@onready var current_player_info = $Info/CurrentPlayerInfo
@onready var current_world_info = $Info/CurrentWorldInfo
@onready var current_train_info = $Info/CurrentTrainInfo
@onready var current_level_info = $Info/CurrentLevelInfo
@onready var current_edge_info = $Info/CurrentEdgeInfo
@onready var current_mission_info = $Info/CurrentMissionInfo
@onready var current_gadget_info = $Info/CurrentGadgetInfo
@onready var current_enemy_info = $Info/CurrentEnemyInfo

var level = preload("res://scenes/level.tscn")

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")

@onready var towns_ui = $TownsUI
@onready var money_label = $WorldUI/MarginContainer/GridContainer/HBoxContainer/MoneyLabel
@onready var mission_inventory_container = $WorldUI/MarginContainer/GridContainer/HBoxContainer/PanelContainer/MissionInventoryContainer

@onready var music_fade = $Music/MusicFade

@onready var world_map = $WorldMap
@onready var world_ui = $WorldUI
@onready var camera = $Camera


var in_game = false
var missions_spawned: bool = false

func start_game(direction, distance, terrain):
	await CurrentRun.root.fade_to_black(1.5)
	
	towns_ui.hide()
	world_map.hide()
	world_ui.hide()
	
	CurrentRun.world.current_level_info.clear_variables()
	CurrentRun.world.current_train_info.clear_variables()

	CurrentRun.world.current_level_info.level_parameters["direction"] = direction
	CurrentRun.world.current_level_info.level_parameters["terrain"] = terrain
	CurrentRun.world.current_level_info.level_parameters["distance"] = distance
	print("Terrain Type: " + LevelInfo.terrain_roster[terrain])
	print("Destination: " + CurrentRun.world.current_level_info.destination)
	print("Distance: " + str(CurrentRun.world.current_level_info.level_parameters["distance"]))

	camera.enabled = false

	if CurrentRun.world.current_player_info.totalExperience == 0:
		CurrentRun.world.current_player_info.set_current_variables_to_base_value()

	for i in CurrentRun.world.current_level_info.events.keys():
		var random_event = LevelInfo.events_roster.keys().pick_random()
		while random_event == "level_complete":
			random_event = LevelInfo.events_roster.keys().pick_random()

		CurrentRun.world.current_level_info.events[i]["type"] = random_event
		print("Event " + str(i) + " = " + str(CurrentRun.world.current_level_info.events[i]["type"]))

	var new_level = level.instantiate()
	add_child(new_level)
	CurrentRun.world.current_level_info.active_level = new_level
	new_level.level_complete_button.pressed.connect(level_complete)
	unpause_game()
	in_game = true
	
	CurrentRun.root.fade_in()

func pause_game():
	if CurrentRun.world.current_level_info.active_level:
		CurrentRun.world.current_level_info.active_level.get_tree().paused = true

func unpause_game():
	if CurrentRun.world.current_level_info.active_level:
		CurrentRun.world.current_level_info.active_level.get_tree().paused = false

func town_clicked(town):
	$TownsUI/MarginContainer/TabContainer.current_tab = 0
	towns_ui.populate_town_info(town)
	if CurrentRun.world.current_world_info.active_town == town.town_name:
		towns_ui.trainyard_items_list.show()
		if missions_spawned == false:
			missions_spawned = true
			towns_ui.spawn_missions(3)
			towns_ui.spawn_trainyard_items()
	else:
		towns_ui.trainyard_items_list.hide()

func _on_travel_button_pressed():
	music_fade.play("world_to_level")
	
	var direction = find_direction()
	var terrain = LevelInfo.terrain_roster.keys().pick_random()
	var distance = find_distance()
	CurrentRun.world.current_level_info.destination = CurrentRun.world.current_world_info.selected_town.town_name

	start_game(direction, distance, terrain)

func find_direction():
	var direction = CurrentRun.world.current_world_info.world_map_player.global_position.direction_to(CurrentRun.world.current_world_info.selected_town.global_position)
	return direction

func find_distance():
	var distance = CurrentRun.world.current_world_info.world_map_player.global_position.distance_to(CurrentRun.world.current_world_info.selected_town.global_position)
	var adjusted_distance = round(clamp(distance*.005,0,8))
	return adjusted_distance

func level_complete():
	music_fade.play("level_to_world")
	await CurrentRun.root.fade_to_black(2)
	
	world_ui.refresh_edges()
	camera.enabled = true
	world_ui.show()
	despawn_level()
	update_world_player_pos()
	check_missions()
	update_money_label()
	world_map.show()
	missions_spawned = false
	
	CurrentRun.root.fade_in()

func update_money_label():
	money_label.text = "Money = $" + str(CurrentRun.world.current_player_info.current_money)

func despawn_level():
	CurrentRun.world.current_level_info.active_level.queue_free()
	remove_child(CurrentRun.world.current_level_info.active_level)
	CurrentRun.world.current_level_info.active_level = null
	CurrentRun.world.current_player_info.active_player = null

func update_world_player_pos():
	world_map.spawn_player()

func check_missions():
	for i in CurrentRun.world.current_mission_info.mission_inventory.keys():
		if CurrentRun.world.current_mission_info.mission_inventory[i]["destination"] == CurrentRun.world.current_world_info.active_town:
			print("Mission Complete: " + str(CurrentRun.world.current_mission_info.mission_inventory[i]["type"]) + " " + str(CurrentRun.world.current_mission_info.mission_inventory[i]["character"]))
			complete_mission(i)

func complete_mission(mission):
	CurrentRun.world.current_player_info.current_money += CurrentRun.world.current_mission_info.mission_inventory[mission]["reward"]
	update_money_label()
	if CurrentRun.world.current_mission_info.mission_inventory[mission].keys().has("icon"):
		world_ui.spawn_reward_panel(CurrentRun.world.current_mission_info.mission_inventory[mission]["icon"], CurrentRun.world.current_mission_info.mission_inventory[mission]["reward"])
	else: 
		var character_icon = CharacterInfo.characters_roster[CurrentRun.world.current_mission_info.mission_inventory[mission]["character"]]["icon"]
		world_ui.spawn_reward_panel(character_icon, CurrentRun.world.current_mission_info.mission_inventory[mission]["reward"])
	for i in mission_inventory_container.get_children():
		if i.mission_id == mission:
			i.queue_free()
			break
	if CurrentRun.world.current_mission_info.mission_inventory.keys().has(mission):
		CurrentRun.world.current_mission_info.mission_inventory.erase(mission)

func upgrade_train(upgrade):
	update_money_label()
	if CurrentRun.world.current_train_info.train_stats.keys().has(upgrade):
		CurrentRun.world.current_train_info.train_stats[upgrade] += TrainInfo.train_upgrade_roster[upgrade]["value"]
		if upgrade == "car_count":
			if CurrentRun.world.current_train_info.cars_inventory.keys().size() > 1:
				var caboose_index = CurrentRun.world.current_train_info.cars_inventory.keys().size() - 1
				CurrentRun.world.current_train_info.cars_inventory[caboose_index + 1] = CurrentRun.world.current_train_info.cars_inventory[caboose_index]
				CurrentRun.world.current_train_info.cars_inventory[caboose_index] = {"node" = null, "type" = null, "hard_points" = {}, "gadgets" = {},}
