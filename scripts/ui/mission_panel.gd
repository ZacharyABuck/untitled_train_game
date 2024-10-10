extends PanelContainer

var mission_type
var character
var destination
var reward
var time_limit

signal clicked

func find_random_mission():
	
	var random_mission_type = MissionInfo.mission_type_roster.keys().pick_random()
	var random_mission = MissionInfo.mission_type_roster[random_mission_type]
	mission_type = random_mission_type
	
	var random_character = CharacterInfo.characters_roster.keys().pick_random()
	character = random_character
	if random_mission.keys().has("icon"):
		$HBoxContainer/MissionIcon.texture = random_mission["icon"]
	else:
		$HBoxContainer/MissionIcon.texture = CharacterInfo.characters_roster[random_character]["icon"]
			
	
	$HBoxContainer/VBoxContainer/MissionName.text = "[center]" + random_mission["name"] + ": " + str(random_character) + "[/center]"
	$HBoxContainer/VBoxContainer/MissionDescription.text = random_mission["description"] + str(destination)
	
	var distance = CurrentRun.world.current_world_info.towns_inventory[destination]["scene"].global_position.distance_to\
	(CurrentRun.world.current_world_info.towns_inventory[CurrentRun.world.current_world_info.active_town]["scene"].global_position)
	
	var random_reward = random_mission["reward"] + round(distance*.002)
	var random_time_limit = randi_range(1,3)
	if random_time_limit > 1:
		$HBoxContainer/VBoxContainer/Reward.text = "Reward: " + str(random_reward) + " scrap      " + str(random_time_limit) + " days"
	else:
		$HBoxContainer/VBoxContainer/Reward.text = "Reward: " + str(random_reward) + " scrap      " + str(random_time_limit) + " day"
	reward = random_reward
	time_limit = random_time_limit
	$Button.mouse_entered.connect(CurrentRun.world.show_travel_line.bind(destination))
	$Button.mouse_exited.connect(CurrentRun.world.camera.reset)

func find_random_destination(max_distance):
	var active_town = CurrentRun.world.current_world_info.towns_inventory[CurrentRun.world.current_world_info.active_town]["scene"]
	var valid_destination: bool = false
	while valid_destination == false:
		var random_destination = CurrentRun.world.current_world_info.towns_inventory.keys().pick_random()
		if CurrentRun.world.current_world_info.towns_inventory[random_destination]["scene"] == active_town or \
		abs(CurrentRun.world.current_world_info.towns_inventory[random_destination]["scene"].global_position.distance_to(active_town.global_position)) > max_distance:
			pass
		else:
			return random_destination
	
func _on_button_pressed():
	var id = randi()
	if CurrentRun.world.current_mission_info.mission_inventory.keys().size() < 3:
		CurrentRun.world.current_mission_info.mission_inventory[id] = \
		{"type" = mission_type,
		"destination" = destination,
		"character" = character,
		"reward" = reward,
		"time_limit" = time_limit,
		"icon" = $HBoxContainer/MissionIcon.texture,}
		clicked.emit(id)
		modulate = Color.TRANSPARENT
		$Button.mouse_filter = MOUSE_FILTER_IGNORE
