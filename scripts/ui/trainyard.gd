extends MarginContainer

var train_car_panel = preload("res://scenes/train/train_car_panel.tscn")
@onready var train_car_container = $HBoxContainer/PanelContainer/MarginContainer/TrainyardItemsList/PanelContainer/TrainCarContainer
@onready var tech_tree = $HBoxContainer/PanelContainer/MarginContainer/TrainyardItemsList/TechTreeContainer/TechTree
var tech_tree_column = preload("res://scenes/ui/tech_tree_column.tscn")

var selected_car
var selected_slot

func spawn_trainyard_items():
	var cars_inventory = CurrentRun.world.current_train_info.cars_inventory
	if !cars_inventory.keys().is_empty():
		for car in cars_inventory.keys():
			var new_panel = spawn_train_car_panel(car)
			new_panel.clicked.connect(populate_tech_tree)

func spawn_train_car_panel(index):
	var new_panel = train_car_panel.instantiate()
	new_panel.car_number = index
	train_car_container.add_child(new_panel)
	
	return new_panel

func close_button_pressed():
	get_parent().close_all_windows()

func populate_tech_tree(gadget, car_number, slot):
	selected_car = car_number
	selected_slot = slot
	
	for i in tech_tree.get_children():
		i.queue_free()
	
	var base_gadget = find_base_gadget(gadget)
	
	var all_upgrades_spawned = false
	var current_gadgets = [base_gadget]
	while all_upgrades_spawned == false:
		var button_index = 0
		var new_column = tech_tree_column.instantiate()
		tech_tree.add_child(new_column)
		new_column.trainyard = self
		
		for i in current_gadgets:
			new_column.set_button_info(new_column.get_child(button_index), i)
			
			if gadget == i: #this gadget
				print("this gadget " + str(i))
				new_column.get_child(button_index).button_pressed = true
				new_column.get_child(button_index).mouse_filter = MOUSE_FILTER_IGNORE
				
			elif find_gadget_downgrades(gadget).has(i): #downgrade
				print("downgrade" + str(i))
				new_column.get_child(button_index).button_pressed = true
				new_column.get_child(button_index).mouse_filter = MOUSE_FILTER_IGNORE
				
			elif GadgetInfo.gadget_roster[i]["last_gadget"] == gadget or GadgetInfo.gadget_roster[i]["last_gadget"] == GadgetInfo.gadget_roster[gadget]["last_gadget"]: #next upgrade
				print("next upgrade " + str(i))
				if CurrentRun.world.current_player_info.current_money >= GadgetInfo.gadget_roster[i]["cost"]:
					new_column.get_child(button_index).mouse_filter = MOUSE_FILTER_STOP
				else:
					new_column.get_child(button_index).mouse_filter = MOUSE_FILTER_IGNORE
			else:
				print("distant upgrade" + str(i))
				new_column.get_child(button_index).disabled = true
			button_index += 1
			
		
		var upgrades = []
		for i in current_gadgets:
			upgrades = find_gadget_upgrades(i)
			current_gadgets.erase(i)
			
		if upgrades.is_empty():
			all_upgrades_spawned = true
			print("all upgrades spawned")
		else:
			current_gadgets.append_array(upgrades)
	
func find_base_gadget(gadget):
	var base_gadget = gadget
	var valid = false
	while valid == false:
		if GadgetInfo.gadget_roster[base_gadget]["last_gadget"] == null:
			valid = true
		else:
			var last_gadget = GadgetInfo.gadget_roster[base_gadget]["last_gadget"]
			base_gadget = last_gadget
	return base_gadget

func find_gadget_upgrades(gadget):
	var upgrades = []
	for g in GadgetInfo.gadget_roster:
		if GadgetInfo.gadget_roster[g]["last_gadget"] == gadget:
			upgrades.append(g)
	return upgrades

func find_gadget_downgrades(gadget):
	var downgrades = []
	var current_gadget = gadget
	while current_gadget != null:
		downgrades.append(GadgetInfo.gadget_roster[current_gadget]["last_gadget"])
		current_gadget = GadgetInfo.gadget_roster[current_gadget]["last_gadget"]
	return downgrades

func upgrade_gadget(gadget):
	
	CurrentRun.world.current_train_info.cars_inventory[selected_car]["gadgets"][selected_slot.name] = gadget
	print(CurrentRun.world.current_train_info.cars_inventory[selected_car])
	populate_tech_tree(gadget, selected_car, selected_slot)
	selected_slot.owner.populate_slot(selected_slot.name, gadget)
