extends Node2D

var player = preload("res://scenes/player.tscn")
@onready var bullets = $Bullets

@onready var build_menu = $UI/BuildMenu
var build_menu_open: bool = false
@onready var gadget_list = $UI/BuildMenu/MarginContainer/GadgetList

@onready var test_track = $test_track



# Called when the node enters the scene tree for the first time.
func _ready():
	generate_track()
	spawn_player()
	populate_build_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/MoneyLabel.text = "Money: $" + str(PlayerInfo.money)

func generate_track():
	var index = 2
	var last_pos = test_track.track.curve.get_point_position(index-1)
	test_track.track.curve.set_point_out(index-1, Vector2(0,-1000))
	for i in LevelInfo.level_parameters["distance"]:
		match LevelInfo.level_parameters["direction"]:
			"NW":
				var pos_options = [Vector2(-3000,-3000), Vector2(-3000,0), Vector2(0,-3000)]
				var random_pos = pos_options.pick_random()
				test_track.track.curve.add_point(last_pos + random_pos)
				test_track.track.curve.set_point_out(index, random_pos*.5)
				test_track.track.curve.set_point_in(index, -random_pos*.2)
				index += 1
				last_pos += random_pos
			"NE":
				var pos_options = [Vector2(3000,-3000), Vector2(3000,0), Vector2(0,-3000)]
				var random_pos = pos_options.pick_random()
				test_track.track.curve.add_point(last_pos + random_pos)
				test_track.track.curve.set_point_out(index, random_pos*.5)
				test_track.track.curve.set_point_in(index, -random_pos*.5)
				index += 1
				last_pos += random_pos

func spawn_player():
	await get_tree().create_timer(1).timeout
	var new_player = player.instantiate()
	new_player.global_position = TrainInfo.train_engine.global_position
	add_child(new_player)

func populate_build_menu():
	for i in GadgetInfo.gadget_roster:
		gadget_list.add_item(GadgetInfo.gadget_roster[i]["name"], GadgetInfo.gadget_roster[i]["sprite"])
		gadget_list.set_item_metadata(gadget_list.item_count-1, GadgetInfo.gadget_roster[i])

func _on_gadget_list_item_clicked(index, _at_position, _mouse_button_index):
	var gadget_info = LevelInfo.active_level.gadget_list.get_item_metadata(index)
	GadgetFunctions.request_gadget(gadget_info)

