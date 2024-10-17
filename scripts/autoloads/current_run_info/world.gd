extends Node2D

@onready var current_player_info = $Info/CurrentPlayerInfo
@onready var current_world_info = $Info/CurrentWorldInfo
@onready var current_train_info = $Info/CurrentTrainInfo
@onready var current_level_info = $Info/CurrentLevelInfo
@onready var current_edge_info = $Info/CurrentEdgeInfo
@onready var current_mission_info = $Info/CurrentMissionInfo
@onready var current_gadget_info = $Info/CurrentGadgetInfo
@onready var current_enemy_info = $Info/CurrentEnemyInfo
@onready var current_character_info = $Info/CurrentCharacterInfo

var level = preload("res://scenes/level.tscn")

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")

@onready var towns_ui = $TownsUI
@onready var money_label = $WorldUI/MarginContainer/GridContainer/HBoxContainer/VBoxContainer/MoneyLabel
@onready var mission_inventory_container = $WorldUI/MarginContainer/GridContainer/HBoxContainer/PanelContainer/MissionInventoryContainer


@onready var music_fade = $Music/MusicFade

@onready var world_map = $WorldMap
@onready var world_ui = $WorldUI
@onready var end_screen_ui = $EndScreenUI
@onready var camera = $Camera
@onready var travel_line = $TravelLine

@onready var debug_ui = $DebugUI

var in_game = false
var missions_spawned: bool = false

func _ready():
	music_fade.play("world_start")
	update_money_label()

func show_travel_line(destination):
	AudioSystem.play_audio("quick_woosh", -10)
	travel_line.points[0] = current_world_info.towns_inventory[current_world_info.active_town]["scene"].global_position
	travel_line.points[1] = current_world_info.towns_inventory[destination]["scene"].global_position
	travel_line.show()
	camera.jump_to_pos(current_world_info.towns_inventory[destination]["scene"].global_position)

func start_game(direction, distance, terrain):
	await CurrentRun.root.fade_to_black(1.5)
	
	towns_ui.hide()
	world_map.hide()
	world_ui.hide()
	
	current_player_info.targets.clear()
	current_level_info.clear_variables()
	current_train_info.clear_variables()

	current_level_info.level_parameters["direction"] = direction
	current_level_info.level_parameters["terrain"] = terrain
	current_level_info.level_parameters["distance"] = distance
	print("Terrain Type: " + LevelInfo.terrain_roster[terrain])
	print("Destination: " + current_level_info.destination)
	print("Distance: " + str(current_level_info.level_parameters["distance"]))
	
	camera.enabled = false

	#find random events
	for i in current_level_info.events.keys():
		var random_event = LevelInfo.events_roster.keys().pick_random()
		while random_event == "level_complete":
			random_event = LevelInfo.events_roster.keys().pick_random()

		current_level_info.events[i]["type"] = random_event
		print("Event " + str(i) + " = " + str(current_level_info.events[i]["type"]))

	var new_level = level.instantiate()
	add_child(new_level)
	current_level_info.active_level = new_level
	unpause_game()
	in_game = true
	
	Input.set_custom_mouse_cursor(load("res://sprites/ui/crosshair.png"), 0, Vector2(32,32))
	
	CurrentRun.root.fade_in()
	
	await get_tree().create_timer(5).timeout
	CurrentRun.root.tutorial_ui.trigger_tutorial("basic_controls")

func pause_game():
	if current_level_info.active_level:
		current_level_info.active_level.get_tree().paused = true

func unpause_game():
	if current_level_info.active_level:
		current_level_info.active_level.get_tree().paused = false

func town_clicked(town):
	camera.jump_to_pos(current_world_info.towns_inventory[town.town_name]["scene"].global_position)
	
	for i in current_world_info.towns_inventory:
		current_world_info.towns_inventory[i]["scene"].hide_travel_info()
	
	if current_world_info.active_town == town.town_name:
		AudioSystem.play_audio("big_select", -10)
		towns_ui.populate_town_info(town)
		if missions_spawned == false:
			missions_spawned = true
			towns_ui.spawn_missions(3)
			if current_world_info.towns_inventory[town.town_name].has("gunsmith"):
				towns_ui.spawn_gunsmith_items()
				towns_ui.gunsmith_button.show()
			if current_world_info.towns_inventory[town.town_name].has("trainyard"):
				towns_ui.trainyard.spawn_trainyard_items()
				towns_ui.trainyard_button.show()
	
	else:
		towns_ui.close_all_windows()
		towns_ui.hide()
		current_world_info.towns_inventory[town.town_name]["scene"].show_travel_info()

func _on_travel_button_pressed():
	if current_train_info.train_stats["fuel_tank"] >= find_fuel_cost():
		music_fade.play("world_to_level")
		current_world_info.selected_town.hide_travel_info()
		var direction = find_direction()
		var terrain = LevelInfo.terrain_roster.keys().pick_random()
		var distance = find_distance()
		current_level_info.destination = current_world_info.selected_town.town_name
		start_game(direction, distance, terrain)

func find_direction():
	var direction = current_world_info.towns_inventory[current_world_info.active_town]["scene"].global_position.direction_to(current_world_info.selected_town.global_position)
	return direction

func find_distance():
	var distance = current_world_info.towns_inventory[current_world_info.active_town]["scene"].global_position.distance_to(current_world_info.selected_town.global_position)
	var adjusted_distance = round(clamp(distance*.005,3,8))
	return adjusted_distance

func find_fuel_cost() -> int:
	var distance = find_distance()
	return distance*current_train_info.train_stats["car_count"]

func level_complete():
	music_fade.play("level_to_world")
	await CurrentRun.root.fade_to_black(2)
	
	Input.set_custom_mouse_cursor(null,0,Vector2.ZERO)
	world_ui.refresh_edges()
	camera.enabled = true
	world_ui.show()
	despawn_level()
	update_world_player_pos()
	check_missions()
	update_money_label()
	current_train_info.set_all_gadget_upkeep(false)
	world_map.show()
	missions_spawned = false
	CurrentRun.root.fade_in()
	
	end_screen_ui.fade_in()

func update_money_label():
	money_label.text = "Money = $" + str("%.2f" % current_player_info.current_money)

func despawn_level():
	current_level_info.active_level.queue_free()
	remove_child(current_level_info.active_level)
	current_level_info.active_level = null
	current_player_info.active_player = null

func update_world_player_pos():
	world_map.spawn_player()

func check_missions():
	var index = 0
	for i in current_mission_info.mission_inventory.keys():
		if current_mission_info.mission_inventory[i]["destination"] == current_world_info.active_town:
			#Mission Complete
			print("Mission Complete: " + str(current_mission_info.mission_inventory[i]["type"]) + " " + str(current_mission_info.mission_inventory[i]["character"]))
			complete_mission(i)
			index += 1
		else:
			current_mission_info.mission_inventory[i]["time_limit"] -= 1
			#Mission Failed
			if current_mission_info.mission_inventory[i]["time_limit"] <= 0:
				end_screen_ui.spawn_reward_panel(false, CharacterInfo.characters_roster[current_mission_info.mission_inventory[i]["character"]]["icon"], current_mission_info.mission_inventory[i]["reward"])
				current_mission_info.mission_inventory.erase(i)
				index += 1
	for i in mission_inventory_container.get_children():
		if !current_mission_info.mission_inventory.keys().has(i.mission_id):
			i.queue_free()
		else:
			i.time_limit_label.text = str(current_mission_info.mission_inventory[i.mission_id]["time_limit"])
	
	if index == 0:
		end_screen_ui.show_no_missions_label()

func complete_mission(mission):
	if current_mission_info.mission_inventory[mission]["reward"].has("money"):
		current_player_info.current_money += current_mission_info.mission_inventory[mission]["reward"]["money"]
		update_money_label()
	if current_mission_info.mission_inventory[mission]["reward"].has("gadget"):
		GadgetInfo.gadget_roster[current_mission_info.mission_inventory[mission]["reward"]["gadget"]]["unlocked"] = true
	if current_mission_info.mission_inventory[mission]["reward"].has("merc"):
		var new_merc_name = find_random_merc()
		var new_merc_type = current_mission_info.mission_inventory[mission]["reward"]["merc"]
		current_character_info.mercs_inventory[new_merc_name] = {"type": new_merc_type, "ranks": {"0": CharacterInfo.mercs_roster[new_merc_type]["ranks"]["0"]}}
	if current_mission_info.mission_inventory[mission].keys().has("icon"):
		end_screen_ui.spawn_reward_panel(true, current_mission_info.mission_inventory[mission]["icon"], current_mission_info.mission_inventory[mission]["reward"])
	else: 
		var character_icon = CharacterInfo.characters_roster[current_mission_info.mission_inventory[mission]["character"]]["icon"]
		end_screen_ui.spawn_reward_panel(true, character_icon, current_mission_info.mission_inventory[mission]["reward"])
	for i in mission_inventory_container.get_children():
		if i.mission_id == mission:
			i.queue_free()
			break
	if current_mission_info.mission_inventory.keys().has(mission):
		current_mission_info.mission_inventory.erase(mission)

func upgrade_train(upgrade):
	update_money_label()
	if current_train_info.train_stats.keys().has(upgrade):
		current_train_info.train_stats[upgrade] += TrainInfo.train_upgrade_roster[upgrade]["value"]
		if upgrade == "car_count":
			if current_train_info.cars_inventory.keys().size() > 1:
				var caboose_index = current_train_info.cars_inventory.keys().size() - 1
				current_train_info.cars_inventory[caboose_index + 1] = current_train_info.cars_inventory[caboose_index]
				current_train_info.cars_inventory[caboose_index] = {"node" = null, "type" = null, "hard_points" = {}, "gadgets" = {},}

func find_random_merc():
	var merc_name = CharacterInfo.characters_roster.keys().pick_random()
	var valid = false
	while valid == false:
		var index = 0
		for merc in current_character_info.mercs_inventory.keys():
			if merc != merc_name:
				index += 1
		if index >= current_character_info.mercs_inventory.keys().size() - 1:
			valid = true
		else:
			merc_name = CharacterInfo.characters_roster.keys().pick_random()
	
	return merc_name
