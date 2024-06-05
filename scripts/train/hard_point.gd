extends Node2D

@onready var sprite = $Sprite2D
@onready var radial_menu = $RadialMenu


var gadget
var location
var car


func respawn_gadget(requested_gadget):
	TrainInfo.cars_inventory[car.index]["gadgets"][get_parent().name] = requested_gadget
	gadget = requested_gadget
	spawn_gadget(requested_gadget)


func add_gadget(requested_gadget):
	var requested_gadget_info = GadgetInfo.gadget_roster[requested_gadget]
	var label = LevelInfo.active_level.alert_label
	# CHECK IF PLAYER HAS ENOUGH MONEY
	if PlayerInfo.current_money < requested_gadget_info["cost"]:
		label.text = "Not Enough Money!"
		label.get_child(0).play("alert_flash_short")
		label.show()
	# CHECK IF CAR ALREADY HAS SURROUNDING GADGET
	elif requested_gadget_info["location"] == "car" and has_car_gadget():
		label.text = "Space Occupied!"
		label.get_child(0).play("alert_flash_short")
		label.show()
	# BUILD GADGET
	else:
		GadgetInfo.selected_gadget = null
		TrainInfo.cars_inventory[car.index]["gadgets"][get_parent().name] = requested_gadget
		LevelInfo.active_level.close_all_ui()
		$BuildSound.play()
		PlayerInfo.current_money -= requested_gadget_info["cost"]
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
		PlayerInfo.state = "default"

func spawn_gadget(gadget):
	var new_gadget = GadgetInfo.gadget_roster[gadget]["scene"].instantiate()
	add_child(new_gadget)
	match GadgetInfo.gadget_roster[gadget]["location"]:
		"hard_point":
			new_gadget.global_position = global_position
		"car":
			new_gadget.global_position = car.global_position
			new_gadget.icon_sprite.global_position = global_position
	radial_menu.close_menu()
	radial_menu.update_menu(gadget)


func has_car_gadget() -> bool:
	for i in car.hard_points.get_children():
		if i.get_child(0).gadget != null:
			var gadget_location = GadgetInfo.gadget_roster[i.get_child(0).gadget]["location"]
			if gadget_location == "car":
				return true
	return false
