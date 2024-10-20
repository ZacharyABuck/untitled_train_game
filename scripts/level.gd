extends Node2D

var player = preload("res://scenes/player/player.tscn")
@onready var bullets = $Bullets

@onready var edge_menu = $UI/EdgeMenu
const edge_panel = preload("res://scenes/edges/edge_panel.tscn")
@onready var alert_label = $UI/AlertLabel

@onready var weapon_label = $UI/WeaponLabel

@onready var enemies = $Enemies
@onready var enemy_spawn_system = $EnemySpawnSystem

@onready var train_manager = $TrainManager
@onready var map = $Map

var spawning: bool = false

var in_event: bool = false

var new_player

var ui_open: bool = false

var weather_states: Array = ["clear", "rain"]
var weather: String
@onready var rain = $UI/Weather/Rain

@onready var rain_animations = $UI/Weather/Rain/RainAnimations


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_track()
	spawn_player()
	CurrentRun.world.current_player_info.route_experience = 0
	calculate_weather()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/MoneyLabel.text = "Money: $" + str("%.2f" % CurrentRun.world.current_player_info.current_money)


func calculate_weather():
	var random_weather = weather_states.pick_random()
	weather = random_weather
	print(random_weather)
	match weather:
		"clear":
			rain_animations.play("fade_out")
		"rain":
			rain_animations.play("fade_in")

func generate_track():
	var point_increment = 3000
	var index = 2
	var last_pos = train_manager.track.curve.get_point_position(index-1)
	
	#set first point to be reverse direction, to load the train
	train_manager.track.curve.set_point_position(0, -point_increment*CurrentRun.world.current_level_info.level_parameters["direction"])
	
	#set each track point per distance
	for i in CurrentRun.world.current_level_info.level_parameters["distance"] + 1:
		var increment = CurrentRun.world.current_level_info.level_parameters["direction"]*point_increment
		var turn_radius = .8
		var random_mod = Vector2(randf_range(-point_increment*turn_radius, point_increment*turn_radius), \
							randf_range(-point_increment*turn_radius, point_increment*turn_radius))
		var random_pos = increment+random_mod
		add_track_point(last_pos, index, random_pos)
		index += 1
		last_pos += random_pos
		var area
		
		#set level complete event on last point
		if i == CurrentRun.world.current_level_info.level_parameters["distance"] -1:
			area = generate_event_area("level_complete", last_pos)
		#set events based on dict
		else:
			for event in CurrentRun.world.current_level_info.events:
				if i == CurrentRun.world.current_level_info.events[event]["distance"]:
					area = generate_event_area(CurrentRun.world.current_level_info.events[event]["type"], last_pos)
					CurrentRun.world.current_level_info.events[event]["area"] = area

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
	new_player.global_position = CurrentRun.world.current_train_info.train_engine.global_position
	CurrentRun.world.current_player_info.state = "default"
	add_child(new_player)
	new_player.dead.connect(CurrentRun.root.show_restart_button)

func enemy_killed():
	enemy_spawn_system.check_for_enemies()

func weapon_picked_up(weapon):
	var random_stats = CurrentRun.world.current_player_info.find_random_weapon_stats()
	var random_damage = random_stats[0]
	var random_attack_delay = random_stats[1]
	var random_projectile_speed = random_stats[2]
	var ammo_count = round(10/WeaponInfo.weapons_roster[weapon]["base_attack_delay"])
	CurrentRun.world.current_player_info.equip_new_weapon(weapon, ammo_count, random_damage, random_attack_delay, random_projectile_speed)

func set_weapon_label(weapon, ammo):
	if weapon == "revolver":
		weapon_label.text = WeaponInfo.weapons_roster[weapon]["name"] + "\n Ammo: inf"
	else:
		weapon_label.text = WeaponInfo.weapons_roster[weapon]["name"] + "\n Ammo: " + str(ammo)

func close_all_ui():
	Engine.time_scale = 1
	for i in CurrentRun.world.current_train_info.cars_inventory:
		CurrentRun.world.current_train_info.cars_inventory[i]["node"].hide_radial_menus()

func pause_game():
	if CurrentRun.world.current_level_info.active_level.get_tree().paused == false:
		CurrentRun.world.current_level_info.active_level.get_tree().paused = true

func unpause_game():
	if CurrentRun.world.current_level_info.active_level.get_tree().paused == true:
		CurrentRun.world.current_level_info.active_level.get_tree().paused = false

func hazard_spawn_timer_timeout():
	var train_engine = CurrentRun.world.current_train_info.train_engine
	if train_engine.velocity >= 10:
		var engine_car = CurrentRun.world.current_train_info.cars_inventory[0]["node"]
		var random_spawn_point = engine_car.hazard_spawn_points.get_children().pick_random().global_position
		var pos = Vector2(random_spawn_point.x + randf_range(-50,50), random_spawn_point.y + randf_range(-50,50))
		var new_hazard = find_random_hazard().instantiate()
		new_hazard.global_position = pos
		add_child(new_hazard)

func find_random_hazard():
	var random_key = LevelInfo.hazards_roster.keys().pick_random()
	var scene = LevelInfo.hazards_roster[random_key]["scene"]
	return scene
