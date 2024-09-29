extends CanvasLayer

var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")
var mission_inventory_panel = preload("res://scenes/ui/mission_inventory_panel.tscn")
var edge_inventory_label = preload("res://scenes/ui/edge_inventory_label.tscn")
@onready var rewards_container = $MarginContainer2/RewardsContainer
@onready var money_label = $MarginContainer/GridContainer/HBoxContainer/VBoxContainer/MoneyLabel
@onready var mission_inventory_container = $MarginContainer/GridContainer/HBoxContainer/PanelContainer/MissionInventoryContainer
@onready var edge_label_container = $MarginContainer/GridContainer/EdgeLabelContainer

func spawn_reward_panel(mission_success, sprite, reward):
	var new_panel = mission_reward_panel.instantiate()
	rewards_container.add_child(new_panel)
	new_panel.populate(mission_success, sprite, reward)

func spawn_mission_inventory_panel(mission):
	var new_panel = mission_inventory_panel.instantiate()
	mission_inventory_container.add_child(new_panel)
	new_panel.populate(mission)

func refresh_edges():
	for label in edge_label_container.get_children():
		label.queue_free()
	for edge in CurrentRun.world.current_edge_info.edge_inventory.keys():
		print("Spawned: " + str(edge))
		spawn_edge_inventory_label(edge)

func spawn_edge_inventory_label(edge):
	var new_label = edge_inventory_label.instantiate()
	edge_label_container.add_child(new_label)
	new_label.populate(edge)
