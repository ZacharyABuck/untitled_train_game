extends PanelContainer

var mission_id

@onready var time_limit_label = $HBoxContainer/CharacterIcon/TimeLimitLabel

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
			description_text = "Take " + str(mission_details["character"]) + " to \n" + str(mission_details["destination"] + reward_text)
		"delivery":
			description_text = "Deliver cargo to \n" + str(mission_details["destination"] + reward_text)
	
	$HBoxContainer/VBoxContainer/MissionDescriptionLabel.text = description_text
	mouse_entered.connect(CurrentRun.world.show_travel_line.bind(mission_details["destination"]))
	time_limit_label.text = str(mission_details["time_limit"])
