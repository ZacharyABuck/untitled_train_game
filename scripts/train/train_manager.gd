extends Node

@export var car_count = 8
@export var train_vehicle_reference : PackedScene

@onready var engine : TrainEngine = $TrainEngine

@onready var track = $Tracks/Track

func _setup_train():
	engine.add_to_track(track)
	engine.car.top_collider.disabled = false
	engine.car.type = "engine"
	var last_vehicle = engine
	last_vehicle.car.index = 0
	TrainInfo.cars_inventory[0] = {"node" = null, "type" = last_vehicle.car.type, "hard_points" = {}, "gadgets" = {},}
	TrainInfo.cars_inventory[0]["node"] = last_vehicle.car
	last_vehicle.car.set_parameters()
	
	for index in range(car_count):
		if index == 0:
			pass
		else:
			var train_vehicle = train_vehicle_reference.instantiate()
			add_child(train_vehicle)
			last_vehicle.set_follower_car(train_vehicle)
			last_vehicle = train_vehicle
			if index == car_count - 1:
				last_vehicle.car.type = "caboose"
				last_vehicle.car.bottom_collider.disabled = false
			else:
				var valid = false
				while valid == false:
					var random_type = TrainInfo.cars_roster.keys().pick_random()
					if random_type != "engine" and random_type != "caboose":
						last_vehicle.car.type = random_type
						valid = true
			last_vehicle.car.index = index
			TrainInfo.cars_inventory[index] = {"node" = null, "type" = last_vehicle.car.type, "hard_points" = {}, "gadgets" = {},}
			TrainInfo.cars_inventory[index]["node"] = last_vehicle.car
			last_vehicle.car.set_parameters()

func _on_timer_timeout() -> void:
	_setup_train()


