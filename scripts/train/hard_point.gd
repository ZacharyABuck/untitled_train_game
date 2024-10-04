extends Node2D

@onready var sprite = $Sprite2D
@onready var radial_menu = $RadialMenu


var gadget
var location
var car


func respawn_gadget(requested_gadget):
	CurrentRun.world.current_train_info.cars_inventory[car.index]["gadgets"][get_parent().name] = requested_gadget
	gadget = requested_gadget
	spawn_gadget(requested_gadget)

func add_gadget(requested_gadget):
	var requested_gadget_info = GadgetInfo.gadget_roster[requested_gadget]
	var label = CurrentRun.world.current_level_info.active_level.alert_label
	# CHECK IF PLAYER HAS ENOUGH MONEY
	#if CurrentRun.world.current_player_info.current_money < requested_gadget_info["cost"]:
		#label.text = "Not Enough Money!"
		#label.get_child(0).play("alert_flash_short")
		#label.show()
	# CHECK IF CAR ALREADY HAS SURROUNDING GADGET
	if requested_gadget_info["location"] == "car" and has_car_gadget():
		label.text = "Space Occupied!"
		label.get_child(0).play("alert_flash_short")
		label.show()
	# BUILD GADGET
	else:
		if GadgetInfo.upgrade_rosters["default"].has(requested_gadget):
			CurrentRun.world.current_gadget_info.gadget_inventory[requested_gadget] = clamp(CurrentRun.world.current_gadget_info.gadget_inventory[requested_gadget] - 1, 0, 100)
		else:
			CurrentRun.world.current_gadget_info.upgrade_kits = clamp(CurrentRun.world.current_gadget_info.upgrade_kits - 1, 0, 100)
		CurrentRun.world.current_gadget_info.selected_gadget = null
		CurrentRun.world.current_train_info.cars_inventory[car.index]["gadgets"][get_parent().name] = requested_gadget
		CurrentRun.world.current_level_info.active_level.close_all_ui()
		$BuildSound.play()
		#CurrentRun.world.current_player_info.current_money -= requested_gadget_info["cost"]
		print("New Gadget: " + requested_gadget_info["name"])
		#delete old gadget if upgrading
		if gadget != null:
			for i in get_children():
				if i.is_in_group("gadget"):
					i.queue_free()
					break
		
		#create gadget
		spawn_gadget(requested_gadget)
		gadget = requested_gadget
		CurrentRun.world.current_player_info.state = "default"

func spawn_gadget(requested_gadget):
	var new_gadget = GadgetInfo.gadget_roster[requested_gadget]["scene"].instantiate()
	add_child(new_gadget)
	
	car.gadgets.append(new_gadget)

	match GadgetInfo.gadget_roster[requested_gadget]["location"]:
		"hard_point":
			new_gadget.global_position = global_position
		"car":
			new_gadget.global_position = car.global_position
			new_gadget.icon_sprite.global_position = global_position
	radial_menu.close_menu()
	radial_menu.update_menu(requested_gadget)


func has_car_gadget() -> bool:
	for i in car.hard_points.get_children():
		if i.get_child(0).gadget != null:
			var gadget_location = GadgetInfo.gadget_roster[i.get_child(0).gadget]["location"]
			if gadget_location == "car":
				return true
	return false
