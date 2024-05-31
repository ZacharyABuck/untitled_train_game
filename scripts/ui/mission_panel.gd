extends PanelContainer

var mission_type

func find_random_mission():
	var random_mission_type = MissionInfo.mission_type_roster.keys().pick_random()
	var random_mission = MissionInfo.mission_type_roster[random_mission_type]
	$HBoxContainer/MissionIcon.texture = random_mission["icon"]
	$HBoxContainer/VBoxContainer/MissionName.text = "[center]" + random_mission["name"] + "[/center]"
	$HBoxContainer/VBoxContainer/MissionDescription.text = random_mission["description"]
	$HBoxContainer/VBoxContainer/Reward.text = "Reward: " + str(random_mission["reward"])
