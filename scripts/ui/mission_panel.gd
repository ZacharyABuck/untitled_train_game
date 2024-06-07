extends PanelContainer

var mission_type
var character
var destination
var reward

signal clicked

func find_random_mission():
	destination = find_random_destination()
	
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
	
	var distance = WorldInfo.towns_inventory[destination]["scene"].global_position.distance_to\
	(WorldInfo.towns_inventory[WorldInfo.active_town]["scene"].global_position)
	
	var random_reward = random_mission["reward"] + round(distance*.01)
	$HBoxContainer/VBoxContainer/Reward.text = "Reward: " + str(random_reward)
	reward = random_reward

func find_random_destination():
	var valid_destination: bool = false
	while valid_destination == false:
		var random_destination = WorldInfo.towns_inventory.keys().pick_random()
		if random_destination == WorldInfo.active_town:
			pass
		else:
			return random_destination

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var id = randi()
		if MissionInfo.mission_inventory.keys().size() < 3:
			MissionInfo.mission_inventory[id] = \
			{"type" = mission_type,
			"destination" = destination,
			"character" = character,
			"reward" = reward,
			"icon" = $HBoxContainer/MissionIcon.texture,}
			clicked.emit(id)
			queue_free()
