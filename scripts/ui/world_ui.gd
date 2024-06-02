extends CanvasLayer

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")
var mission_inventory_panel = preload("res://scenes/ui/mission_inventory_panel.tscn")
@onready var rewards_container = $MarginContainer2/RewardsContainer
@onready var money_label = $MarginContainer/GridContainer/HBoxContainer/MoneyLabel
@onready var mission_inventory_container = $MarginContainer/GridContainer/HBoxContainer/PanelContainer/MissionInventoryContainer



func spawn_reward_panel(character, reward):
	var new_panel = mission_reward_panel.instantiate()
	rewards_container.add_child(new_panel)
	new_panel.populate(CharacterInfo.characters_roster[character]["icon"], reward)

func spawn_mission_inventory_panel(mission):
	var new_panel = mission_inventory_panel.instantiate()
	mission_inventory_container.add_child(new_panel)
	new_panel.populate(mission)
