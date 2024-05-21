extends Node2D

@export var car_count = 8
@export var train_vehicle_reference : PackedScene

@onready var engine : TrainEngine = $TrainEngine

@onready var track = $Tracks/Track

@onready var mesh_vis = $TrainCollision/MeshVis


func _ready():
	TrainInfo.train_manager = self
#
#func _process(delta):
	#mesh_vis.global_position = engine.car.top_center.position

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
	
