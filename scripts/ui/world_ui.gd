extends CanvasLayer

var mission_inventory_panel = preload("res://scenes/ui/mission_inventory_panel.tscn")
var edge_inventory_label = preload("res://scenes/ui/edge_inventory_label.tscn")

@onready var mission_inventory_container = $PanelContainer/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/MissionInventoryContainer
@onready var edge_label_container = $PanelContainer/MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/EdgeLabelContainer

func _ready():
	hide()

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

func _input(event):
	if event.is_action_pressed("inventory"):
		if visible:
			hide()
			get_parent().unpause_game()
		else:
			show()
			get_parent().pause_game()
	
