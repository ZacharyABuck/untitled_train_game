extends Node

func add_gadget(gadget, hard_point, car):
	#assign gadget to hard point
	hard_point.gadget = GadgetInfo.selected_gadget
	#subtract cost from money
	PlayerInfo.money -= gadget["cost"]
	#reset gadget selection state
	GadgetInfo.selected_gadget = null
	GadgetInfo.selection_active = false
	#stop hard points from flashing
	for i in TrainInfo.cars_inventory[car.index]["hard_points"]:
		TrainInfo.cars_inventory[car.index]["hard_points"][i].animation_player.play("still")
		TrainInfo.cars_inventory[car.index]["hard_points"][i].sprite.modulate = Color.WHITE
	#instantiate the new gadget
	var new_gadget = gadget["scene"].instantiate()
	car.gadgets.add_child(new_gadget)
	TrainInfo.cars_inventory[car.index]["gadgets"][TrainInfo.cars_inventory[car.index]["gadgets"].size()] = new_gadget
	new_gadget.global_position = hard_point.global_position
	#close build menu and unpause
	LevelInfo.root.build_menu.hide()
	LevelInfo.root.build_menu_open = false
	LevelInfo.root.unpause_game()
