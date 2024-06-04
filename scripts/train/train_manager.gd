extends Node2D

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
	
	var need_cargo_car: bool = false
	for i in MissionInfo.mission_inventory:
		if MissionInfo.mission_inventory[i]["type"] == "delivery":
			need_cargo_car = true
	
	for index in range(TrainInfo.train_stats["car_count"]):
		#skip train engine
		if index == 0:
			pass
		else:
			var train_vehicle = train_vehicle_reference.instantiate()
			add_child(train_vehicle)
			last_vehicle.set_follower_car(train_vehicle)
			last_vehicle = train_vehicle
			
			if index == TrainInfo.train_stats["car_count"] - 1:
				last_vehicle.car.type = "caboose"
				last_vehicle.car.bottom_collider.disabled = false
			#if route has passengers
			elif need_passenger_car:
				last_vehicle.car.type = "passenger"
				need_passenger_car = false
				last_vehicle.car.spawn_characters()
			#if route has cargo
			elif need_cargo_car:
				last_vehicle.car.type = "cargo"
				need_cargo_car = false
				last_vehicle.car.spawn_cargo()
			#set to cargo car if nothing else
			else:
				last_vehicle.car.type = "cargo"
			last_vehicle.car.index = index
			#check if its a new car
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
	
	for right_side_point in range(0, TrainInfo.cars_inventory.keys().size(), 1):
		verts.append(TrainInfo.cars_inventory[right_side_point]["node"].top_right.global_position)
		verts.append(TrainInfo.cars_inventory[right_side_point]["node"].bottom_right.global_position)
	
	for left_side_point in range(TrainInfo.cars_inventory.keys().size() - 1, -1, -1):
		verts.append(TrainInfo.cars_inventory[left_side_point]["node"].bottom_left.global_position)
		verts.append(TrainInfo.cars_inventory[left_side_point]["node"].top_left.global_position)

	mesh_vis.set_polygon(verts)
	
