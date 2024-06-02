extends Node2D

@export var car_count = 8
@export var train_vehicle_reference : PackedScene

@onready var engine : TrainEngine = $TrainEngine

@onready var track = $Tracks/Track

@onready var mesh_vis = $TrainCollision/MeshVis


func _ready():
	TrainInfo.train_manager = self

func _setup_train():
	engine.add_to_track(track)
	engine.car.top_collider.disabled = false
	engine.car.type = "engine"
	var last_vehicle = engine
	last_vehicle.car.index = 0
	if TrainInfo.cars_inventory.keys().size() == 0:
		TrainInfo.cars_inventory[0] = {"node" = null, "type" = last_vehicle.car.type, "hard_points" = {}, "gadgets" = {},}
	TrainInfo.cars_inventory[0]["node"] = last_vehicle.car
	last_vehicle.car.set_parameters()
	last_vehicle.car.check_for_gadgets()
	
	var need_passenger_car: bool = false
	for i in MissionInfo.mission_inventory:
		if MissionInfo.mission_inventory[i]["type"] == "escort":
			need_passenger_car = true
	
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
			elif need_passenger_car:
				last_vehicle.car.type = "passenger"
				need_passenger_car = false
				last_vehicle.car.spawn_characters()
			else:
				last_vehicle.car.type = "coal"
			last_vehicle.car.index = index
			if TrainInfo.cars_inventory.keys().size() - 1 < index:
				TrainInfo.cars_inventory[index] = {"node" = null, "type" = last_vehicle.car.type, "hard_points" = {}, "gadgets" = {},}
			else:
				pass
			TrainInfo.cars_inventory[index]["node"] = last_vehicle.car
			last_vehicle.car.set_parameters()
			last_vehicle.car.check_for_gadgets()

func _on_timer_timeout() -> void:
	_setup_train()

func add_to_mesh():
	var verts: PackedVector2Array = []
	
	verts.append(TrainInfo.cars_inventory[0]["node"].top_left.global_position)
	verts.append(TrainInfo.cars_inventory[0]["node"].top_right.global_position)
	verts.append(TrainInfo.cars_inventory[0]["node"].bottom_right.global_position)
	
	verts.append(TrainInfo.cars_inventory[1]["node"].top_right.global_position)
	verts.append(TrainInfo.cars_inventory[1]["node"].bottom_right.global_position)
	
	verts.append(TrainInfo.cars_inventory[2]["node"].top_right.global_position)
	verts.append(TrainInfo.cars_inventory[2]["node"].bottom_right.global_position)
	
	verts.append(TrainInfo.cars_inventory[3]["node"].top_right.global_position)
	verts.append(TrainInfo.cars_inventory[3]["node"].bottom_right.global_position)
	verts.append(TrainInfo.cars_inventory[3]["node"].bottom_left.global_position)
	verts.append(TrainInfo.cars_inventory[3]["node"].top_left.global_position)
	
	verts.append(TrainInfo.cars_inventory[2]["node"].bottom_left.global_position)
	verts.append(TrainInfo.cars_inventory[2]["node"].top_left.global_position)
	
	verts.append(TrainInfo.cars_inventory[1]["node"].bottom_left.global_position)
	verts.append(TrainInfo.cars_inventory[1]["node"].top_left.global_position)
	
	verts.append(TrainInfo.cars_inventory[0]["node"].bottom_left.global_position)

	mesh_vis.set_polygon(verts)
	
