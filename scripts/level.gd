extends Node2D

@onready var train = $Train
var player = preload("res://scenes/player.tscn")
@onready var bullets = $Bullets

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_train()
	spawn_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_train():
	var index = 0
	for i in train.car_spawn_positions.get_children():
		var new_car = train.car.instantiate()
		new_car.position = i.position
		train.cars.add_child(new_car)
		if i == train.car_spawn_positions.get_child(0):
			new_car.top_collider.disabled = false
			new_car.type = "engine"
		elif i == train.car_spawn_positions.get_child(train.car_spawn_positions.get_child_count()-1):
			new_car.type = "caboose"
			new_car.bottom_collider.disabled = false
		else:
			var valid = false
			while valid == false:
				var random_type = TrainInfo.cars_roster.keys().pick_random()
				if random_type != "engine" and random_type != "caboose":
					new_car.type = random_type
					valid = true
		new_car.set_parameters()
		TrainInfo.cars_inventory[index] = {"node" = null, "type" = null}
		TrainInfo.cars_inventory[index]["node"] = new_car
		TrainInfo.cars_inventory[index]["type"] = new_car.type
		index += 1
		print(TrainInfo.cars_inventory)

func spawn_player():
	var new_player = player.instantiate()
	new_player.global_position = train.cars.get_child(0).global_position
	add_child(new_player)


