extends Node2D

var player = preload("res://scenes/player.tscn")
@onready var bullets = $Bullets

@onready var edge_menu = $UI/EdgeMenu
var edge_menu_open: bool = false
@onready var edge_list = $UI/EdgeMenu/EdgeContainer/EdgeList
@onready var alert_label = $UI/AlertLabel
@onready var enemies = $Enemies
@onready var train_manager = $TrainManager
@onready var enemy_spawn_positions = $EnemySpawnPositions
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var xp_bar = $UI/PlayerExperienceBar
@onready var level_label = $UI/LevelLabel
@onready var xp_label = $UI/ExperienceLabel
@onready var level_up_animation = $UI/LevelUpAnimation
var new_player

var ui_open: bool = false

@onready var world_light = $WorldLight
@onready var day_cycle_timer = $WorldLight/DayCycleTimer
var is_day: bool = true
var in_event: bool = false
var max_night_light: float = .75

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_track()
	spawn_player()
	ExperienceSystem.level_up.connect(self.handle_level_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UI/MoneyLabel.text = "Money: $" + str(PlayerInfo.current_money)
	# These XP functions will be moved to a dedicated node or func that handles all this.
	xp_bar.value = PlayerInfo.currentExperience
	xp_bar.max_value = PlayerInfo.nextLevelExperience
	level_label.text = "Level: " + str(PlayerInfo.currentLevel)
	xp_label.text = "XP: " + str(PlayerInfo.currentExperience) + " / " + str(PlayerInfo.nextLevelExperience)
	calculate_day_cycle()
	$UI/PlayerExperienceBar.value = PlayerInfo.currentExperience
	
	#set enemy spawn positions to follow train
	if TrainInfo.train_engine != null:
		enemy_spawn_positions.global_position = TrainInfo.train_engine.global_position
		enemy_spawn_positions.global_rotation = TrainInfo.train_engine.car.global_rotation
	
	#set difficulty level
	LevelInfo.difficulty = Time.get_ticks_msec()*LevelInfo.difficulty_increase_rate

#set the day time in the tree
func calculate_day_cycle():
	if !day_cycle_timer.is_stopped():
		var percent = ((day_cycle_timer.wait_time-day_cycle_timer.time_left)/day_cycle_timer.wait_time)
		#first go to night time
		if is_day:
			world_light.energy = clamp(max_night_light*percent, 0, max_night_light)
		#then go back to daytime
		else:
			world_light.energy = clamp(max_night_light-(max_night_light*percent), 0, max_night_light)

func instant_night():
	day_cycle_timer.stop()
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(world_light, "energy", max_night_light, 1)

func instant_day():
	is_day = true
	var tween = get_tree().create_tween().bind_node(self)
	await tween.tween_property(world_light, "energy", 0, 1)
	day_cycle_timer.start()

func _on_day_cycle_timer_timeout():
	if is_day:
		is_day = false
	else:
		is_day = true
	await get_tree().create_timer(day_cycle_timer.wait_time*.25).timeout
	day_cycle_timer.start()

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

func _on_enemy_spawn_timer_timeout():
	var start_time = 5
	#adjust to difficulty level
	enemy_spawn_timer.wait_time = clamp(start_time - LevelInfo.difficulty,.5,5)
	
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

func close_all_ui():
	ui_open = false
	Engine.time_scale = 1
	for i in TrainInfo.cars_inventory:
		TrainInfo.cars_inventory[i]["node"].hide_radial_menus()

func pause_game():
	LevelInfo.active_level.get_tree().paused = true

func unpause_game():
	LevelInfo.active_level.get_tree().paused = false

