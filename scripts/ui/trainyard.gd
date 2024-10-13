extends MarginContainer

var train_car_panel = preload("res://scenes/train/train_car_panel.tscn")
@onready var train_car_container = $HBoxContainer/PanelContainer/MarginContainer/TrainyardItemsList/PanelContainer/TrainCarContainer


func spawn_trainyard_items():
	var cars_inventory = CurrentRun.world.current_train_info.cars_inventory
	if !cars_inventory.keys().is_empty():
		for car in cars_inventory.keys():
			var new_panel = spawn_train_car_panel(car)

func spawn_train_car_panel(index):
	var new_panel = train_car_panel.instantiate()
	new_panel.car_number = index
	train_car_container.add_child(new_panel)
	
	return new_panel


func close_button_pressed():
	get_parent().close_all_windows()
