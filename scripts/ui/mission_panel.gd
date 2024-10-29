extends PanelContainer

var mission_type
var character
var rewards = {}

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

	if random_mission["reward"] == "gadget":
		var random_gadget = GadgetInfo.find_random_locked_gadget()
		if random_gadget != null:
			rewards["gadget"] = random_gadget
			$HBoxContainer/VBoxContainer/HBoxContainer/Reward.text = "Gadget Unlock"

	if random_mission["reward"] == "merc":
		var random_merc_type = CharacterInfo.mercs_roster.keys().pick_random()
		if random_merc_type != null:
			rewards["merc"] = random_merc_type
			$HBoxContainer/VBoxContainer/HBoxContainer/Reward.text = "Merc Joins Your Crew"

func _on_button_pressed():
	var id = randi()
	if CurrentRun.world.current_mission_info.mission_inventory.keys().size() < 3:
		CurrentRun.world.current_mission_info.mission_inventory[id] = \
		{"type" = mission_type,
		"character" = character,
		"reward" = rewards,
		"icon" = $HBoxContainer/MissionIcon.texture,}
		clicked.emit(id)
		modulate = Color.TRANSPARENT
		$Button.mouse_filter = MOUSE_FILTER_IGNORE
