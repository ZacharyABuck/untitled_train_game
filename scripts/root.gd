extends Node2D

var level = preload("res://scenes/level.tscn")

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")

@onready var towns_ui = $TownsUI
@onready var money_label = $WorldUI/MarginContainer/GridContainer/HBoxContainer/MoneyLabel
@onready var mission_inventory_container = $WorldUI/MarginContainer/GridContainer/HBoxContainer/PanelContainer/MissionInventoryContainer

@onready var world_map = $WorldMap
@onready var world_ui = $WorldUI
@onready var camera = $Camera


var in_game = false

func start_game(direction, terrain):
	$WorldUI.hide()
	LevelInfo.clear_variables()
	TrainInfo.clear_variables()
	LevelInfo.level_parameters["direction"] = direction
	LevelInfo.level_parameters["terrain"] = terrain
	camera.enabled = false
	if PlayerInfo.totalExperience == 0:
		PlayerInfo.set_current_variables_to_base_value()
	print("Terrain Type: " + LevelInfo.terrain_roster[terrain])
	print("Destination: " + LevelInfo.destination)
	print(MissionInfo.mission_inventory)
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
	LevelInfo.active_level.get_tree().paused = true

func unpause_game():
	LevelInfo.active_level.get_tree().paused = false

func town_clicked(town):
	towns_ui.populate_town_info(town)

func _on_travel_button_pressed():
	var direction = find_direction()
	var terrain = LevelInfo.terrain_roster.keys().pick_random()
	LevelInfo.destination = WorldInfo.selected_town.town_name
	towns_ui.hide()
	$WorldMap.hide()
	if direction.x < 0 and direction.y < 0:
		start_game("NW", terrain)
	elif direction.x > 0 and direction.y < 0:
		start_game("NE", terrain)
	elif direction.x == 0 and direction.y < 0:
		start_game("N", terrain)
	elif direction.x > 0 and direction.y == 0:
		start_game("E", terrain)
	elif direction.x < 0 and direction.y > 0:
		start_game("SW", terrain)
	elif direction.x > 0 and direction.y > 0:
		start_game("SE", terrain)
	elif direction.x == 0 and direction.y > 0:
		start_game("S", terrain)
	elif direction.x < 0 and direction.y == 0:
		start_game("W", terrain)

func find_direction():
	var direction = WorldInfo.world_map_player.global_position.direction_to(WorldInfo.selected_town.global_position)
	return direction

func level_complete():
	camera.enabled = true
	$WorldUI.show()
	despawn_level()
	update_world_player_pos()
	money_label.text = "Money = $" + str(PlayerInfo.current_money)
	check_missions()
	$WorldMap.show()

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
	money_label.text = "Money = $" + str(PlayerInfo.current_money)
	world_ui.spawn_reward_panel(MissionInfo.mission_inventory[mission]["character"], MissionInfo.mission_inventory[mission]["reward"])
	for i in mission_inventory_container.get_children():
		if i.mission_id == mission:
			i.queue_free()
			break
	MissionInfo.mission_inventory.erase(mission)
