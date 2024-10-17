extends PanelContainer

@onready var mission_label = $HBoxContainer/MarginContainer/VBoxContainer/MissionLabel
@onready var icon = $HBoxContainer/Icon
@onready var reward_label = $HBoxContainer/MarginContainer/VBoxContainer/RewardLabel

func populate(mission_success, sprite, reward_value):
	icon.texture = sprite
	if mission_success:
		if reward_value.has("money"):
			reward_label.text = "Reward: $" + str(reward_value["money"])
		if reward_value.has("gadget"):
			reward_label.text = reward_label.text + "\n" + str(GadgetInfo.gadget_roster[reward_value["gadget"]]["name"]) + " Unlocked!"
		if reward_value.has("merc"):
			reward_label.text = reward_label.text + "\n" + "New Merc Joined!"
	else:
		mission_label.text = "[center]Mission Failed[/center]"
		mission_label.modulate = Color.RED
		reward_label.text = ""
