extends CanvasLayer

@onready var town_name_label = %TownNameLabel
@onready var town_description = %TownDescription
@onready var town_image = %TownImage
@onready var travel_button = %TravelButton

@onready var missions_container = %MissionsContainer
@onready var missions_label = %MissionsLabel
@onready var no_missions_label = %NoMissionsLabel
@onready var trainyard_items_list = %TrainyardItemsList

var trainyard_item = preload("res://scenes/ui/trainyard_item.tscn")
var mission_panel = preload("res://scenes/ui/mission_panel.tscn")

func populate_town_info(town):
	#active town clicked
	CurrentRun.world.current_world_info.selected_town = town
	if CurrentRun.world.current_world_info.active_town == town.town_name:
		no_missions_label.hide()
		travel_button.hide()
		for i in missions_container.get_children():
			i.show()
	else:
		for i in missions_container.get_children():
			i.hide()
		no_missions_label.show()
		var fuel_cost = CurrentRun.world.find_fuel_cost()
		if fuel_cost > CurrentRun.world.current_train_info.train_stats["fuel_tank"]:
			travel_button.text = "Travel to Town (" + str(fuel_cost) + "gal, Too Far!)"
		else:
			travel_button.text = "Travel to Town (" + str(fuel_cost) + "gal)"
		travel_button.show()
	town_name_label.text = "[center]" + town.town_name + "[/center]"
	show()

func _on_close_button_pressed():
	hide()

func spawn_missions(count):
	for i in missions_container.get_children():
		if i == missions_label:
			pass
		else:
			i.queue_free()
	for i in count:
		var new_mission = mission_panel.instantiate()
		missions_container.add_child(new_mission)
		new_mission.find_random_mission()
		new_mission.clicked.connect(owner.world_ui.spawn_mission_inventory_panel)

func spawn_trainyard_items():
	for i in trainyard_items_list.get_children():
		i.queue_free()
	for i in TrainInfo.train_upgrade_roster.keys():
		var new_item = trainyard_item.instantiate()
		trainyard_items_list.add_child(new_item)
		new_item.populate(i)
		new_item.clicked.connect(owner.upgrade_train)
