extends Node2D

var level = preload("res://scenes/level.tscn")

var mission_panel = preload("res://scenes/ui/mission_panel.tscn")
@onready var missions_container = $TownsUI/MarginContainer/MarginContainer/HBoxContainer/MissionDetails/MarginContainer/MissionsContainer
@onready var towns_ui = $TownsUI

var in_game = false

func find_direction():
	print(WorldInfo.world_map_player.global_position.distance_to(WorldInfo.selected_town.global_position))
	var direction = WorldInfo.world_map_player.global_position.direction_to(WorldInfo.selected_town.global_position)
	return direction

func level_option_pressed(button):
	start_game(button.name, button.get_meta("terrain"))

func start_game(direction, terrain):
	LevelInfo.clear_variables()
	TrainInfo.clear_variables()
	LevelInfo.level_parameters["direction"] = direction
	LevelInfo.level_parameters["terrain"] = terrain
	print("Terrain Type: " + LevelInfo.terrain_roster[terrain])
	for i in LevelInfo.events.keys():
		LevelInfo.events[i]["type"] = LevelInfo.events_roster.keys().pick_random()
		print("Event " + str(i) + " = " + str(LevelInfo.events[i]["type"]))
	var new_level = level.instantiate()
	add_child(new_level)
	LevelInfo.active_level = new_level
	unpause_game()
	LevelInfo.root = self
	in_game = true

func pause_game():
	LevelInfo.active_level.get_tree().paused = true

func unpause_game():
	LevelInfo.active_level.get_tree().paused = false

func level_complete():
	pause_game()

func town_clicked(town):
	if missions_container.get_child_count() > 1:
		pass
	else:
		var mission_count = 3
		WorldInfo.selected_town = town
		for i in mission_count:
			var new_mission = mission_panel.instantiate()
			missions_container.add_child(new_mission)
			new_mission.find_random_mission()
	towns_ui.show()
	

func _on_close_button_pressed():
	towns_ui.hide()

func _on_travel_button_pressed():
	var direction = find_direction()
	var terrain = LevelInfo.terrain_roster.keys().pick_random()
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
