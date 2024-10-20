extends MarginContainer

var train_car_panel = preload("res://scenes/train/train_car_panel.tscn")
var tech_tree_column = preload("res://scenes/ui/tech_tree_column.tscn")
@onready var train_car_container = $PanelContainer/MarginContainer/TrainyardItemsList/HBoxContainer2/VBoxContainer/PanelContainer/TrainCarContainer
@onready var tech_tree = $PanelContainer/MarginContainer/TrainyardItemsList/HBoxContainer2/VBoxContainer/TechTreeContainer/MarginContainer/HBoxContainer/TechTree
@onready var tech_tree_label = $PanelContainer/MarginContainer/TrainyardItemsList/HBoxContainer2/VBoxContainer/HBoxContainer/TechTreeLabel

@onready var pay_upkeep_button = $PanelContainer/MarginContainer/TrainyardItemsList/HBoxContainer2/VBoxContainer/HBoxContainer/PayUpkeepButton
@onready var pay_all_upkeep_button = $PanelContainer/MarginContainer/TrainyardItemsList/HBoxContainer2/VBoxContainer/HBoxContainer/PayAllUpkeepButton
var upkeep_cost_mod: float = 0.2

@onready var mercs = $PanelContainer/MarginContainer/TrainyardItemsList/HBoxContainer2/MercsContainer/Mercs
var held_merc

var hovered_car_panel
var selected_car
var selected_slot

func spawn_trainyard_items():
	for child in train_car_container.get_children():
		child.queue_free()
	
	var cars_inventory = CurrentRun.world.current_train_info.cars_inventory
	if !cars_inventory.keys().is_empty():
		for car in cars_inventory.keys():
			var new_panel = spawn_train_car_panel(car)
			new_panel.clicked.connect(panel_clicked)
			new_panel.mouse_detector.mouse_entered.connect(preview_merc_placement.bind(new_panel))
			new_panel.mouse_detector.mouse_exited.connect(dismiss_merc_placement.bind(new_panel))
	
	var merc_container = preload("res://scenes/ui/merc_container.tscn")
	for merc_panel in mercs.get_children():
		merc_panel.queue_free()
	
	for merc in CurrentRun.world.current_character_info.mercs_inventory.keys():
		var new_merc = merc_container.instantiate()
		var equipped_panel = null
		for car in cars_inventory.keys():
			if cars_inventory[car]["merc"] == merc:
				for panel in train_car_container.get_children():
					if panel.car_number == car:
						equipped_panel = panel
		if equipped_panel != null:
			equipped_panel.mouse_detector.add_child(new_merc)
			equipped_panel.equipped_merc_panel = new_merc
		else:
			mercs.add_child(new_merc)
		new_merc.populate(merc)
		new_merc.button.button_down.connect(merc_held.bind(new_merc))
		new_merc.button.button_up.connect(merc_released.bind(new_merc))

func merc_held(merc_panel):
	AudioSystem.play_audio("basic_button_click", -10)
	await get_tree().create_timer(.1).timeout
	if merc_panel.button.button_pressed == true and merc_panel.get_parent() == mercs:
		#if merc panel is moved
		held_merc = merc_panel
		merc_panel.held = true
	else:
		if "equipped_merc_panel" in merc_panel.get_parent().owner:
			merc_panel.get_parent().owner.equipped_merc_panel = null
		reset_merc(merc_panel)

func merc_released(merc_panel):
	if merc_panel.held:
		reset_merc(merc_panel)
	else:
		if hovered_car_panel != null:
			merc_panel.place(hovered_car_panel)
			held_merc = null
			clear_tech_tree()
		else:
			populate_tech_tree(merc_panel)

func reset_merc(merc_panel):
	for i in CurrentRun.world.current_train_info.cars_inventory.keys():
		if CurrentRun.world.current_train_info.cars_inventory[i]["merc"] == merc_panel.merc_name:
			CurrentRun.world.current_train_info.cars_inventory[i]["merc"] = null
	
	var index = merc_panel.get_index()
	hovered_car_panel = null
	held_merc = null
	merc_panel.held = false
	merc_panel.get_parent().remove_child(merc_panel)
	mercs.add_child(merc_panel)
	mercs.move_child(merc_panel,index)

func preview_merc_placement(panel):
	if held_merc != null and panel.equipped_merc_panel == null:
		hovered_car_panel = panel
		held_merc.held = false
		held_merc.preview(panel)

func dismiss_merc_placement(_panel):
	if held_merc != null:
		hovered_car_panel = null
		held_merc.held = true

func spawn_train_car_panel(index):
	var new_panel = train_car_panel.instantiate()
	new_panel.car_number = index
	train_car_container.add_child(new_panel)
	return new_panel

func close_button_pressed():
	get_parent().close_all_windows()

func reset():
	selected_slot = null
	selected_car = null
	pay_all_upkeep_button.hide()
	pay_upkeep_button.hide()
	for i in tech_tree.get_children():
		i.queue_free()
	tech_tree_label.clear()
	$SlotArrow.hide()

func panel_clicked(gadget, car_number, slot):
	tech_tree_label.text = "[center]" + GadgetInfo.gadget_roster[gadget]["name"] + "[/center]"
	selected_car = car_number
	selected_slot = slot
	check_upkeep()

func move_slot_arrow():
	var slot_arrow = $SlotArrow
	slot_arrow.global_position = Vector2(selected_slot.global_position.x + selected_slot.size.x*.5, selected_slot.global_position.y)
	slot_arrow.show()

func check_upkeep():
	if !pay_upkeep_button.pressed.is_connected(pay_upkeep):
		pay_upkeep_button.pressed.connect(pay_upkeep.bind(pay_upkeep_button))
	if !pay_all_upkeep_button.pressed.is_connected(pay_upkeep):
		pay_all_upkeep_button.pressed.connect(pay_upkeep.bind(pay_all_upkeep_button))
	
	if CurrentRun.world.current_train_info.cars_inventory[selected_car]["gadgets"].has(selected_slot.name):
		var gadget_dict = CurrentRun.world.current_train_info.cars_inventory[selected_car]["gadgets"][selected_slot.name]
		if gadget_dict["upkeep_paid"]:
			pay_upkeep_button.hide()
			check_all_upkeep()
		else:
			pay_upkeep_button.text = "Pay Upkeep: $" +  str("%.2f" % (GadgetInfo.gadget_roster[gadget_dict["gadget"]]["cost"]*upkeep_cost_mod))
			pay_upkeep_button.set_meta("cost", GadgetInfo.gadget_roster[gadget_dict["gadget"]]["cost"]*upkeep_cost_mod)
			pay_upkeep_button.show()
			check_all_upkeep()

func check_all_upkeep():
	var amount: float = 0.0
	for car in CurrentRun.world.current_train_info.cars_inventory:
		for gadget in CurrentRun.world.current_train_info.cars_inventory[car]["gadgets"]:
			if CurrentRun.world.current_train_info.cars_inventory[car]["gadgets"][gadget]["upkeep_paid"] == false:
				amount += GadgetInfo.gadget_roster[CurrentRun.world.current_train_info.cars_inventory[car]\
							["gadgets"][gadget]["gadget"]]["cost"]*upkeep_cost_mod
	if amount > 0:
		pay_all_upkeep_button.text = "Pay All Upkeep: $" + str("%.2f" % amount)
		pay_all_upkeep_button.set_meta("cost", amount)
		pay_all_upkeep_button.show()
	else:
		pay_all_upkeep_button.hide()

func pay_upkeep(button):
	var cost = button.get_meta("cost")
	if CurrentRun.world.current_player_info.current_money >= cost:
		CurrentRun.world.current_player_info.current_money -= cost
		CurrentRun.world.update_money_label()
	
		if button.name == "PayAllUpkeepButton":
			for car in CurrentRun.world.current_train_info.cars_inventory:
				for gadget in CurrentRun.world.current_train_info.cars_inventory[car]["gadgets"]:
					CurrentRun.world.current_train_info.cars_inventory[car]["gadgets"][gadget]["upkeep_paid"] = true
			pay_all_upkeep_button.hide()
			pay_upkeep_button.hide()
		else:
			CurrentRun.world.current_train_info.cars_inventory[selected_car]["gadgets"][selected_slot.name]["upkeep_paid"] = true
			pay_upkeep_button.hide()
			check_all_upkeep()

func clear_tech_tree():
	for column in tech_tree.get_children():
		column.queue_free()
	
	tech_tree_label.text = ""

func populate_tech_tree(merc_panel):
	for column in tech_tree.get_children():
		column.queue_free()
	
	tech_tree_label.text = merc_panel.merc_name
	
	for rank in CharacterInfo.mercs_roster[merc_panel.merc_type]["ranks"].keys():
		var new_column = tech_tree_column.instantiate()
		tech_tree.add_child(new_column)
		new_column.trainyard = self
		var button_index = 0
		
		for upgrade in CharacterInfo.mercs_roster[merc_panel.merc_type]["ranks"][rank].keys():
			var new_upgrade = CharacterInfo.mercs_roster[merc_panel.merc_type]["ranks"][rank][upgrade]
			
			if new_upgrade.has("cost"):
				new_column.get_child(button_index).text = new_upgrade["name"] + "\n Upgrade: " + str(new_upgrade["cost"])
			else:
				new_column.get_child(button_index).text = new_upgrade["name"]
			
			new_column.get_child(button_index).set_meta("merc", merc_panel.merc_name)
			new_column.get_child(button_index).set_meta("rank", rank)
			new_column.get_child(button_index).set_meta("upgrade", upgrade)
			new_column.get_child(button_index).show()
			
			#if upgrade is owned
			if CurrentRun.world.current_character_info.mercs_inventory[merc_panel.merc_name]["ranks"].has(rank):
				#if the same rank upgrade is owned
				if CurrentRun.world.current_character_info.mercs_inventory[merc_panel.merc_name]["ranks"][rank].has(upgrade):
					new_column.get_child(button_index).button_pressed = true
					new_column.get_child(button_index).mouse_filter = MOUSE_FILTER_IGNORE
				else:
					new_column.get_child(button_index).mouse_filter = MOUSE_FILTER_IGNORE
					new_column.get_child(button_index).disabled = true
			#if upgrade is next
			elif !CurrentRun.world.current_character_info.mercs_inventory[merc_panel.merc_name]["ranks"].has(rank) and \
				CurrentRun.world.current_character_info.mercs_inventory[merc_panel.merc_name]["ranks"].has(str(int(rank) - 1)):
					new_column.get_child(button_index).mouse_filter = MOUSE_FILTER_STOP
			#disable all other buttons
			else:
				new_column.get_child(button_index).mouse_filter = MOUSE_FILTER_IGNORE
				new_column.get_child(button_index).disabled = true
			
			button_index += 1

func tech_tree_button_pressed(merc):
	for i in mercs.get_children():
		if i.merc_name == merc:
			populate_tech_tree(i)

