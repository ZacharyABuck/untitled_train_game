extends Node2D

@onready var train = $Train
var player = preload("res://scenes/player.tscn")
@onready var bullets = $Bullets

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_train()
	spawn_player()
	populate_build_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/MoneyLabel.text = "Money: $" + str(PlayerInfo.money)

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
		new_car.index = index
		TrainInfo.cars_inventory[index] = {"node" = null, "type" = new_car.type, "hard_points" = {}, "gadgets" = {},}
		TrainInfo.cars_inventory[index]["node"] = new_car
		new_car.set_parameters()
		index += 1

func spawn_player():
	var new_player = player.instantiate()
	new_player.global_position = train.cars.get_child(0).global_position
	add_child(new_player)

func populate_build_menu():
	for i in GadgetInfo.gadget_roster:
		get_parent().item_list.add_item(GadgetInfo.gadget_roster[i]["name"], GadgetInfo.gadget_roster[i]["sprite"])
		get_parent().item_list.set_item_metadata(get_parent().item_list.item_count-1, GadgetInfo.gadget_roster[i])

func request_gadget(gadget):
	if PlayerInfo.money >= gadget["cost"]:
		var hard_points = PlayerInfo.active_player.active_car.hard_points.get_children()
		for i in hard_points:
			i.get_child(0).animation_player.play("flash")
			i.get_child(0).selection_sprite.texture = gadget["sprite"]
		GadgetInfo.selected_gadget = gadget
		GadgetInfo.selection_active = true
