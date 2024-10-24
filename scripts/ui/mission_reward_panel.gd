extends PanelContainer

@onready var mission_label = $HBoxContainer/MarginContainer/VBoxContainer/MissionLabel
@onready var icon = $HBoxContainer/Icon
@onready var reward_label = $HBoxContainer/MarginContainer/VBoxContainer/RewardLabel

func populate(mission_success, mission):
	icon.texture = CharacterInfo.characters_roster[mission["character"]]["icon"]
	var reward = mission["reward"]
	if mission_success:
		if reward.has("gadget"):
			reward_label.text = str(GadgetInfo.gadget_roster[reward["gadget"]]["name"]) + " unlocked!"
		if reward.has("merc"):
			reward_label.text = mission["character"] + " joined your crew!"
	else:
		mission_label.text = "[center]Mission Failed[/center]"
		mission_label.modulate = Color.RED
		reward_label.text = ""
