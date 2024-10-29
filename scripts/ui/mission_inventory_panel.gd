extends PanelContainer

var mission_id

func populate(mission):
	var mission_details = CurrentRun.world.current_mission_info.mission_inventory[mission]
	mission_id = mission
	if mission_details.keys().has("icon"):
		$HBoxContainer/CharacterIcon.texture = mission_details["icon"]
	else:
		$HBoxContainer/CharacterIcon.texture = CharacterInfo.characters_roster[mission_details["character"]]["icon"]
	
	var description_text
	var reward_text
	if mission_details["reward"].has("gadget"):
		reward_text = "\nGadget Unlock"
	if mission_details["reward"].has("merc"):
		reward_text = "\nNew Merc"
	match mission_details["type"]:
		"escort":
			description_text = "Escort " + str(mission_details["character"]) + "\n Reward: " + reward_text
		"delivery":
			description_text = "Deliver cargo \n Reward: " + reward_text
	
	$HBoxContainer/VBoxContainer/MissionDescriptionLabel.text = description_text
