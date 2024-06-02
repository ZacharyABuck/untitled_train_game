extends PanelContainer

var mission_id

func populate(mission):
	var mission_details = MissionInfo.mission_inventory[mission]
	mission_id = mission
	$HBoxContainer/CharacterIcon.texture = CharacterInfo.characters_roster[mission_details["character"]]["icon"]
	
	var description_text
	match mission_details["type"]:
		"escort":
			description_text = "Take " + str(mission_details["character"]) + " to \n" + str(mission_details["destination"])
	
	$HBoxContainer/VBoxContainer/MissionDescriptionLabel.text = description_text
