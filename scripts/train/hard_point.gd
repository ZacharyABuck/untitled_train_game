extends Node2D

@onready var sprite = $Sprite2D
@onready var radial_menu = $RadialMenu


var gadget
var location
var car


func respawn_gadget(requested_gadget):
	gadget = requested_gadget
	spawn_gadget(requested_gadget)

func add_gadget(requested_gadget):
	var requested_gadget_info = GadgetInfo.gadget_roster[requested_gadget]
	var label = CurrentRun.world.current_level_info.active_level.alert_label
	# CHECK IF CAR ALREADY HAS SURROUNDING GADGET
	if requested_gadget_info["location"] == "car" and has_car_gadget():
		label.text = "Space Occupied!"
		label.get_child(0).play("alert_flash_short")
		label.show()
	
	else:
		#check if player has enough money
		if CurrentRun.world.current_player_info.current_money >= requested_gadget_info["cost"]:
			
			CurrentRun.world.current_player_info.current_money -= requested_gadget_info["cost"]
			CurrentRun.world.update_money_label()
			
			CurrentRun.world.current_gadget_info.selected_gadget = null
			
			CurrentRun.world.current_train_info.cars_inventory[car.index]["gadgets"][get_parent().name] = {"gadget" = requested_gadget, "upkeep_paid" = true}
			CurrentRun.world.current_level_info.active_level.close_all_ui()
			$BuildSound.play()
			
			print("New Gadget: " + requested_gadget_info["name"])
			
			#delete old gadget if upgrading
			delete_gadget()
			
			#create gadget
			spawn_gadget(requested_gadget)
			gadget = requested_gadget
			CurrentRun.world.current_player_info.state = "default"

func sell_gadget(gadget):
	var sell_value = GadgetInfo.gadget_roster[gadget]["cost"]*.5
	CurrentRun.world.current_player_info.current_money += sell_value
	CurrentRun.world.update_money_label()
	CurrentRun.world.current_train_info.cars_inventory[car.index]["gadgets"][get_parent().name].clear()
	CurrentRun.world.current_level_info.active_level.close_all_ui()
	CurrentRun.world.current_player_info.state = "default"
	radial_menu.close_menu()
	radial_menu.update_menu(null)
	AudioSystem.play_audio("metal_dropping", -15)
	delete_gadget()

func delete_gadget():
	if gadget != null:
		for i in get_children():
			if i.is_in_group("gadget"):
				i.queue_free()
				break

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
