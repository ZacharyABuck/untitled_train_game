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

@onready var music_fade = $Music/MusicFade
@onready var world_ui = $WorldUI
@onready var end_screen_ui = $EndScreenUI


@onready var debug_ui = $DebugUI

var in_game = false

func _ready():
	current_level_info.destination = WorldInfo.towns_roster.keys().pick_random()

func start_game(direction, distance, terrain):
	await CurrentRun.root.fade_to_black(1.5)

	world_ui.hide()
	
	current_player_info.targets.clear()
	current_level_info.clear_variables()
	current_train_info.clear_variables()
	
	current_level_info.destination = find_random_destination()

	current_world_info.last_route.clear()
	current_world_info.last_route.append(current_world_info.active_town)
	current_world_info.last_route.append(current_level_info.destination)

	current_level_info.level_parameters["direction"] = direction
	current_level_info.level_parameters["terrain"] = terrain
	current_level_info.level_parameters["distance"] = distance
	
	print("Terrain Type: " + LevelInfo.terrain_roster[terrain])
	print("Destination: " + current_level_info.destination)
	print("Distance: " + str(current_level_info.level_parameters["distance"]))

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

	CurrentRun.root.fade_in()
	
	await get_tree().create_timer(5).timeout
	CurrentRun.root.tutorial_ui.trigger_tutorial("basic_controls")

func pause_game():
	if current_level_info.active_level:
		current_level_info.active_level.get_tree().paused = true

func unpause_game():
	if current_level_info.active_level:
		current_level_info.active_level.get_tree().paused = false

func find_random_destination():
	var random_town = WorldInfo.towns_roster.keys().pick_random()
	while current_world_info.towns_inventory.has(random_town):
		random_town = WorldInfo.towns_roster.keys().pick_random()
	
	return random_town

func level_complete(level_complete_event):
	current_level_info.active_level.at_destination = true
	
	current_level_info.active_level.enemy_spawn_system.enemy_wave_timer.stop()
	current_level_info.active_level.enemy_spawn_system.spawn_interval_timer.stop()
	current_level_info.active_level.hazard_spawn_timer.stop()
	for enemy in current_level_info.active_level.enemies.get_children():
		enemy.queue_free()
	
	current_train_info.train_engine.target_force_percent += 3
	
	await level_complete_event.last_car_entered
	await get_tree().create_timer(3).timeout
	
	level_complete_event.player_boundary.get_child(0).set_deferred("disabled", false)
	current_train_info.train_manager.mesh_vis.set_deferred("disabled", true)
	current_player_info.active_player.call_deferred("reparent", current_level_info.active_level)
	current_train_info.train_engine.target_force_percent = 0
	current_train_info.train_engine.brake_force = 3.0
	
	check_missions()
	end_screen_ui.fade_in()

func despawn_level():
	current_level_info.active_level.queue_free()
	remove_child(current_level_info.active_level)
	current_level_info.active_level = null
	current_player_info.active_player = null

func check_missions():
	#clear end screen ui
	for i in end_screen_ui.mission_complete_container.get_children():
		i.queue_free()

	for i in current_mission_info.mission_inventory.keys():
		#Mission Complete
		complete_mission(i)

	#refresh tab inventory of missions
	for i in world_ui.mission_inventory_container.get_children():
		if !current_mission_info.mission_inventory.keys().has(i.mission_id):
			i.queue_free()

func complete_mission(mission):
	if current_mission_info.mission_inventory[mission]["reward"].has("gadget"):
		current_gadget_info.unlocked_gadgets.append(current_mission_info.mission_inventory[mission]["reward"]["gadget"])
	if current_mission_info.mission_inventory[mission]["reward"].has("merc"):
		var new_merc_name = current_mission_info.mission_inventory[mission]["character"]
		var new_merc_type = current_mission_info.mission_inventory[mission]["reward"]["merc"]
		current_character_info.mercs_inventory[new_merc_name] = {"type": new_merc_type, "ranks": {"0": CharacterInfo.mercs_roster[new_merc_type]["ranks"]["0"]}}
	if current_mission_info.mission_inventory[mission].keys().has("icon"):
		end_screen_ui.spawn_reward_panel(true, current_mission_info.mission_inventory[mission])
	else: 
		end_screen_ui.spawn_reward_panel(true, current_mission_info.mission_inventory[mission])
	for i in world_ui.mission_inventory_container.get_children():
		if i.mission_id == mission:
			i.queue_free()
			break
	if current_mission_info.mission_inventory.keys().has(mission):
		current_mission_info.mission_inventory.erase(mission)

