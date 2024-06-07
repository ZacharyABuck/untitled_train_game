extends Node2D

var level = preload("res://scenes/level.tscn")

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")

@onready var towns_ui = $World/TownsUI
@onready var money_label = $World/WorldUI/MarginContainer/GridContainer/HBoxContainer/MoneyLabel
@onready var mission_inventory_container = $World/WorldUI/MarginContainer/GridContainer/HBoxContainer/PanelContainer/MissionInventoryContainer

@onready var world_map = $World/WorldMap
@onready var world_ui = $World/WorldUI
@onready var camera = $World/Camera

@onready var escape_menu = $EscapeMenu
@onready var title_screen = $TitleScreen
@onready var restart_screen = $RestartScreen


@onready var music_fade = $World/Music/MusicFade


func ready():
	title_screen.show()
	

func title_screen_start_button_pressed():
	title_screen.hide()

var in_game = false
var missions_spawned: bool = false

func _input(event):
	if event.is_action_pressed("escape_menu"):
		if escape_menu.visible:
			escape_menu.hide()
			escape_menu.reset()
			unpause_game()
		else:
			pause_game()
			escape_menu.show()

func start_game(direction, distance, terrain):
	world_ui.hide()
	LevelInfo.clear_variables()
	TrainInfo.clear_variables()

	LevelInfo.level_parameters["direction"] = direction
	LevelInfo.level_parameters["terrain"] = terrain
	LevelInfo.level_parameters["distance"] = distance
	print("Terrain Type: " + LevelInfo.terrain_roster[terrain])
	print("Destination: " + LevelInfo.destination)
	print("Distance: " + str(LevelInfo.level_parameters["distance"]))

	camera.enabled = false

	if PlayerInfo.totalExperience == 0:
		PlayerInfo.set_current_variables_to_base_value()

	for i in LevelInfo.events.keys():
		LevelInfo.events[i]["type"] = LevelInfo.events_roster.keys().pick_random()
		print("Event " + str(i) + " = " + str(LevelInfo.events[i]["type"]))

	var new_level = level.instantiate()
	add_child(new_level)
	LevelInfo.active_level = new_level
	new_level.level_complete_button.pressed.connect(level_complete)
	unpause_game()
	LevelInfo.root = self
	in_game = true

func pause_game():
	if LevelInfo.active_level:
		LevelInfo.active_level.get_tree().paused = true

func unpause_game():
	if LevelInfo.active_level:
		LevelInfo.active_level.get_tree().paused = false

func show_restart_button():
	restart_screen.show()
	pause_game()

func restart_button_button_up():
	if PlayerInfo.active_player:
		PlayerInfo.active_player.queue_free()
	if LevelInfo.active_level:
		LevelInfo.active_level.queue_free()
	
	TrainInfo.restart()
	LevelInfo.restart()
	PlayerInfo.restart()
	WorldInfo.restart()
	world_map.clear()
	get_tree().reload_current_scene()

func town_clicked(town):
	$World/TownsUI/MarginContainer/TabContainer.current_tab = 0
	towns_ui.populate_town_info(town)
	if WorldInfo.active_town == town.town_name:
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
	LevelInfo.destination = WorldInfo.selected_town.town_name
	towns_ui.hide()
	world_map.hide()
	start_game(direction, distance, terrain)

func find_direction():
	var direction = WorldInfo.world_map_player.global_position.direction_to(WorldInfo.selected_town.global_position)
	return direction

func find_distance():
	var distance = WorldInfo.world_map_player.global_position.distance_to(WorldInfo.selected_town.global_position)
	var adjusted_distance = round(clamp(distance*.005,0,8))
	return adjusted_distance

func level_complete():
	music_fade.play("level_to_world")
	world_ui.refresh_edges()
	camera.enabled = true
	world_ui.show()
	despawn_level()
	update_world_player_pos()
	check_missions()
	update_money_label()
	world_map.show()
	missions_spawned = false

func update_money_label():
	money_label.text = "Money = $" + str(PlayerInfo.current_money)

func despawn_level():
	LevelInfo.active_level.queue_free()
	LevelInfo.active_level = null
	PlayerInfo.active_player = null

func update_world_player_pos():
	world_map.spawn_player()

func check_missions():
	for i in MissionInfo.mission_inventory.keys():
		if MissionInfo.mission_inventory[i]["destination"] == WorldInfo.active_town:
			print("Mission Complete: " + str(MissionInfo.mission_inventory[i]["type"]) + " " + str(MissionInfo.mission_inventory[i]["character"]))
			complete_mission(i)

func complete_mission(mission):
	PlayerInfo.current_money += MissionInfo.mission_inventory[mission]["reward"]
	update_money_label()
	if MissionInfo.mission_inventory[mission].keys().has("icon"):
		world_ui.spawn_reward_panel(MissionInfo.mission_inventory[mission]["icon"], MissionInfo.mission_inventory[mission]["reward"])
	else: 
		var character_icon = CharacterInfo.characters_roster[MissionInfo.mission_inventory[mission]["character"]]["icon"]
		world_ui.spawn_reward_panel(character_icon, MissionInfo.mission_inventory[mission]["reward"])
	for i in mission_inventory_container.get_children():
		if i.mission_id == mission:
			i.queue_free()
			break
	if MissionInfo.mission_inventory.keys().has(mission):
		MissionInfo.mission_inventory.erase(mission)

func upgrade_train(upgrade):
	update_money_label()
	if TrainInfo.train_stats.keys().has(upgrade):
		TrainInfo.train_stats[upgrade] += TrainInfo.train_upgrade_roster[upgrade]["value"]
		if upgrade == "car_count":
			if TrainInfo.cars_inventory.keys().size() > 1:
				var caboose_index = TrainInfo.cars_inventory.keys().size() - 1
				TrainInfo.cars_inventory[caboose_index + 1] = TrainInfo.cars_inventory[caboose_index]
				TrainInfo.cars_inventory[caboose_index] = {"node" = null, "type" = null, "hard_points" = {}, "gadgets" = {},}


