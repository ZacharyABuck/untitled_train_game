extends PanelContainer

var mission_type
var character
var destination
var rewards = {}
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
	
	var random_money = random_mission["reward"] + round(distance*.002)
	rewards["money"] = random_money
	$HBoxContainer/VBoxContainer/HBoxContainer/Reward.text = "Reward: $" + str(random_money)
	

	var rng = randi_range(1,4)
	if rng == 1:
		var random_gadget = GadgetInfo.find_random_locked_gadget()
		if random_gadget != null:
			rewards["gadget"] = random_gadget
			$HBoxContainer/VBoxContainer/HBoxContainer/Reward.text = $HBoxContainer/VBoxContainer/HBoxContainer/Reward.text + "\n + Gadget Unlock"
	if rng == 2:
		var random_merc_type = CharacterInfo.mercs_roster.keys().pick_random()
		if random_merc_type != null:
			rewards["merc"] = random_merc_type
			$HBoxContainer/VBoxContainer/HBoxContainer/Reward.text = $HBoxContainer/VBoxContainer/HBoxContainer/Reward.text + "\n + Merc Joins Your Crew"
	
	var random_time_limit = randi_range(1,3)
	if random_time_limit > 1:
		$HBoxContainer/VBoxContainer/HBoxContainer/TimeLimit.text = str(random_time_limit) + " days"
	else:
		$HBoxContainer/VBoxContainer/HBoxContainer/TimeLimit.text = str(random_time_limit) + " day"
	
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
		"reward" = rewards,
		"time_limit" = time_limit,
		"icon" = $HBoxContainer/MissionIcon.texture,}
		clicked.emit(id)
		modulate = Color.TRANSPARENT
		$Button.mouse_filter = MOUSE_FILTER_IGNORE
