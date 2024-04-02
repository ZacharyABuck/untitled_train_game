extends Node2D

@onready var train = $Train
var player = preload("res://scenes/player.tscn")
@onready var bullets = $Bullets

@onready var build_menu = $UI/BuildMenu
var build_menu_open: bool = false
@onready var gadget_list = $UI/BuildMenu/MarginContainer/GadgetList


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_train()
	spawn_player()
	populate_build_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/MoneyLabel.text = "Money: $" + str(PlayerInfo.money)

func spawn_train():
	pass
	#var index = 0
	#for i in train.car_spawn_positions.get_children():
		#var new_car = train.car.instantiate()
		#new_car.position = i.position
		#train.cars.add_child(new_car)
		#if i == train.car_spawn_positions.get_child(0):
			#new_car.top_collider.disabled = false
			#new_car.type = "engine"
		#elif i == train.car_spawn_positions.get_child(train.car_spawn_positions.get_child_count()-1):
			#new_car.type = "caboose"
			#new_car.bottom_collider.disabled = false
		#else:
			#var valid = false
			#while valid == false:
				#var random_type = TrainInfo.cars_roster.keys().pick_random()
				#if random_type != "engine" and random_type != "caboose":
					#new_car.type = random_type
					#valid = true
		#new_car.index = index
		#TrainInfo.cars_inventory[index] = {"node" = null, "type" = new_car.type, "hard_points" = {}, "gadgets" = {},}
		#TrainInfo.cars_inventory[index]["node"] = new_car
		#new_car.set_parameters()
		#index += 1

func spawn_player():
	await get_tree().create_timer(1).timeout
	var new_player = player.instantiate()
	$Train/test_track.engine.add_child(new_player)

func populate_build_menu():
	for i in GadgetInfo.gadget_roster:
		gadget_list.add_item(GadgetInfo.gadget_roster[i]["name"], GadgetInfo.gadget_roster[i]["sprite"])
		gadget_list.set_item_metadata(gadget_list.item_count-1, GadgetInfo.gadget_roster[i])

func _on_gadget_list_item_clicked(index, _at_position, _mouse_button_index):
	var gadget_info = LevelInfo.active_level.gadget_list.get_item_metadata(index)
	GadgetFunctions.request_gadget(gadget_info)

