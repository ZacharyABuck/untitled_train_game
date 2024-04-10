extends Node2D

var player = preload("res://scenes/player.tscn")
@onready var bullets = $Bullets

@onready var build_menu = $UI/BuildMenu
var build_menu_open: bool = false
@onready var gadget_list = $UI/BuildMenu/MarginContainer/GadgetList
@onready var alert_label = $UI/AlertLabel

@onready var train_manager = $TrainManager


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
	var last_pos = train_manager.track.curve.get_point_position(index-1)
	train_manager.track.curve.set_point_position(index-1, last_pos*.5)
	var random_pos
	var pos_options
	match LevelInfo.level_parameters["direction"]:
		"NW":
			pos_options = [Vector2(-point_increment,-point_increment), Vector2(-point_increment,0), Vector2(0,-point_increment)]
		"NE":
			pos_options = [Vector2(point_increment,-point_increment), Vector2(point_increment,0), Vector2(0,-point_increment)]
		"SW":
			train_manager.track.curve.set_point_position(0, -train_manager.track.curve.get_point_position(0))
			pos_options = [Vector2(-point_increment,point_increment), Vector2(-point_increment,0), Vector2(0,point_increment)]
		"SE":
			train_manager.track.curve.set_point_position(0, -train_manager.track.curve.get_point_position(0))
			pos_options = [Vector2(point_increment,point_increment), Vector2(point_increment,0), Vector2(0,point_increment)]
	for i in LevelInfo.level_parameters["distance"]:
		random_pos = pos_options.pick_random()
		add_track_point(last_pos, index, random_pos)
		index += 1
		last_pos += random_pos
		for event in LevelInfo.events:
			if i == LevelInfo.events[event]["distance"]:
				var area = generate_event_area(last_pos)
				LevelInfo.events[event]["area"] = area

func generate_event_area(pos):
	var area = Area2D.new()
	add_child(area)
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = load("res://shapes/shape_event_trigger.tres")
	area.add_child(collision_shape)
	area.set_collision_layer_value(8, true)
	area.set_collision_mask_value(3, true)
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	collision_shape.debug_color = Color.DEEP_PINK
	area.monitoring = true
	area.monitorable = true
	area.area_entered.connect(event_triggered)
	area.body_entered.connect(event_triggered)
	area.global_position = train_manager.track.curve.get_closest_point(to_local(pos))
	return area
	
func add_track_point(last_pos, index, random_pos):
	train_manager.track.curve.add_point(last_pos + random_pos*.5)
	train_manager.track.curve.set_point_out(index, random_pos*.3)
	train_manager.track.curve.set_point_in(index, -random_pos*.5)
	if index == 2:
		train_manager.track.curve.set_point_out(index-1, random_pos*.3)
		train_manager.track.curve.set_point_in(index-1, -random_pos*.5)

func spawn_player():
	await get_tree().create_timer(.5).timeout
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

func event_triggered(object):
	for event in LevelInfo.events:
		if LevelInfo.events[event]["triggered"] == false:
			LevelInfo.events[event]["area"].queue_free()
			print("event triggered")
			LevelInfo.events[event]["triggered"] = true
			TrainInfo.train_engine.brake_force = 5
			var new_event = load("res://scenes/event.tscn").instantiate()
			new_event.global_position = TrainInfo.train_engine.car.obstacle_spawn_position.global_position
			LevelInfo.root.call_deferred("add_child", new_event)
			alert_label.show()
			break

func event_finished():
	TrainInfo.train_engine.brake_force = 0
	alert_label.hide()
