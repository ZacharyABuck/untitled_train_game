extends Node2D

var player = preload("res://scenes/player.tscn")
@onready var bullets = $Bullets

@onready var build_menu = $UI/BuildMenu
var build_menu_open: bool = false
@onready var edge_menu = $UI/EdgeMenu
var edge_menu_open: bool = false
@onready var gadget_list = $UI/BuildMenu/MarginContainer/GadgetList
@onready var edge_list = $UI/EdgeMenu/EdgeContainer/EdgeList
@onready var alert_label = $UI/AlertLabel
@onready var enemies = $Enemies
@onready var train_manager = $TrainManager
@onready var xp_bar = $UI/PlayerExperienceBar
@onready var level_label = $UI/LevelLabel
@onready var xp_label = $UI/ExperienceLabel
@onready var level_up_animation = $UI/LevelUpAnimation
var new_player


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_track()
	spawn_player()
	populate_build_menu()
	ExperienceSystem.level_up.connect(self.handle_level_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/MoneyLabel.text = "Money: $" + str(PlayerInfo.current_money)
	# These XP functions will be moved to a dedicated node or func that handles all this.
	xp_bar.value = PlayerInfo.currentExperience
	xp_bar.max_value = PlayerInfo.nextLevelExperience
	level_label.text = "Level: " + str(PlayerInfo.currentLevel)
	xp_label.text = "XP: " + str(PlayerInfo.currentExperience) + " / " + str(PlayerInfo.nextLevelExperience)

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
				var area = generate_event_area(LevelInfo.events[event]["type"], last_pos)
				LevelInfo.events[event]["area"] = area

func generate_event_area(type, pos):
	var area = EventArea.new()
	area.global_position = train_manager.track.curve.get_closest_point(to_local(pos))
	area.type = type
	add_child(area)
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
	new_player = player.instantiate()
	new_player.global_position = TrainInfo.train_engine.global_position
	add_child(new_player)

func populate_build_menu():
	for i in GadgetInfo.gadget_roster:
		gadget_list.add_item(GadgetInfo.gadget_roster[i]["name"], GadgetInfo.gadget_roster[i]["sprite"])
		gadget_list.set_item_metadata(gadget_list.item_count-1, GadgetInfo.gadget_roster[i])

func _on_gadget_list_item_clicked(index, _at_position, _mouse_button_index):
	var gadget_info = LevelInfo.active_level.gadget_list.get_item_metadata(index)
	GadgetFunctions.request_gadget(gadget_info)

func _on_enemy_spawn_timer_timeout():
	var new_spawner = EnemySpawner.new()
	add_child(new_spawner)
	var random_enemy = new_spawner.find_random_enemy()
	new_spawner.spawn_enemy(1, random_enemy, null)


func handle_level_up():
	level_up_animation.play("level_up")
	pause_game()
	populate_edge_menu()
	LevelInfo.active_level.edge_menu.show()
	edge_menu_open = true

# Edge Menu
func populate_edge_menu():
	for edge in EdgeInfo.edge_roster:
		edge_list.add_item(EdgeInfo.edge_roster[edge]["name"], EdgeInfo.edge_roster[edge]["sprite"])
		edge_list.set_item_metadata(edge_list.item_count-1, EdgeInfo.edge_roster[edge])

func _on_edge_list_item_clicked(index, at_position, mouse_button_index):
	var edge_info = LevelInfo.active_level.edge_list.get_item_metadata(index)
	new_player.edge_handler.add_edge(edge_info)
	LevelInfo.active_level.edge_menu.hide()
	edge_list.clear()
	unpause_game()

func pause_game():
	LevelInfo.active_level.get_tree().paused = true

func unpause_game():
	LevelInfo.active_level.get_tree().paused = false

