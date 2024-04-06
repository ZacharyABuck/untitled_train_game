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
	var point_increment = 3000
	var index = 2
	var last_pos = test_track.track.curve.get_point_position(index-1)
	test_track.track.curve.set_point_position(index-1, last_pos*.5)
	var random_pos
	var pos_options
	match LevelInfo.level_parameters["direction"]:
		"NW":
			pos_options = [Vector2(-point_increment,-point_increment), Vector2(-point_increment,0), Vector2(0,-point_increment)]
		"NE":
			pos_options = [Vector2(point_increment,-point_increment), Vector2(point_increment,0), Vector2(0,-point_increment)]
		"SW":
			test_track.track.curve.set_point_position(0, -test_track.track.curve.get_point_position(0))
			pos_options = [Vector2(-point_increment,point_increment), Vector2(-point_increment,0), Vector2(0,point_increment)]
		"SE":
			test_track.track.curve.set_point_position(0, -test_track.track.curve.get_point_position(0))
			pos_options = [Vector2(point_increment,point_increment), Vector2(point_increment,0), Vector2(0,point_increment)]
	for i in LevelInfo.level_parameters["distance"]:
		random_pos = pos_options.pick_random()
		add_track_point(last_pos, index, random_pos)
		index += 1
		last_pos += random_pos

func add_track_point(last_pos, index, random_pos):
	test_track.track.curve.add_point(last_pos + random_pos*.5)
	test_track.track.curve.set_point_out(index, random_pos*.3)
	test_track.track.curve.set_point_in(index, -random_pos*.5)
	if index == 2:
		test_track.track.curve.set_point_out(index-1, random_pos*.3)
		test_track.track.curve.set_point_in(index-1, -random_pos*.5)

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

