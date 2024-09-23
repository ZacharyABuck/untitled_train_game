extends Node2D

var player = preload("res://scenes/player/player.tscn")
@onready var bullets = $Bullets

@onready var edge_menu = $UI/EdgeMenu
const edge_panel = preload("res://scenes/edges/edge_panel.tscn")
@onready var alert_label = $UI/AlertLabel
@onready var enemies = $Enemies
@onready var train_manager = $TrainManager
@onready var map = $Map
@onready var enemy_spawn_positions = $EnemySpawnPositions
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var xp_bar = $UI/PlayerExperienceBar
@onready var level_label = $UI/LevelLabel
@onready var xp_label = $UI/ExperienceLabel
@onready var level_up_button = $UI/LevelUpButton
@onready var level_complete_button = $UI/LevelCompleteButton

var new_player

var ui_open: bool = false

@onready var world_light = $WorldLight
@onready var day_cycle_timer = $WorldLight/DayCycleTimer
var is_day: bool = true
var in_event: bool = false
var max_night_light: float = .75

var weather_states: Array = ["clear", "rain"]
var weather: String
@onready var rain_animations = $UI/Weather/Rain/RainAnimations


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_track()
	spawn_player()
	ExperienceSystem.level_up.connect(self.handle_level_up)
	calculate_weather()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/MoneyLabel.text = "Money: $" + str(CurrentRun.world.current_player_info.current_money)
	# These XP functions will be moved to a dedicated node or func that handles all this.
	xp_bar.value = CurrentRun.world.current_player_info.currentExperience
	xp_bar.max_value = CurrentRun.world.current_player_info.nextLevelExperience
	level_label.text = "Level: " + str(CurrentRun.world.current_player_info.currentLevel)
	xp_label.text = "XP: " + str(CurrentRun.world.current_player_info.currentExperience) + " / " + str(CurrentRun.world.current_player_info.nextLevelExperience)
	calculate_day_cycle()
	$UI/PlayerExperienceBar.value = CurrentRun.world.current_player_info.currentExperience
	
	#set enemy spawn positions to follow train
	if CurrentRun.world.current_train_info.train_engine != null:
		enemy_spawn_positions.global_position = CurrentRun.world.current_train_info.train_engine.global_position
		enemy_spawn_positions.global_rotation = CurrentRun.world.current_train_info.train_engine.car.global_rotation

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
		
		
func calculate_weather():
	var random_weather = weather_states.pick_random()
	weather = random_weather
	print(random_weather)
	match weather:
		"clear":
			rain_animations.play("fade_out")
		"rain":
			rain_animations.play("fade_in")

func instant_night():
	day_cycle_timer.stop()
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(world_light, "energy", max_night_light, 1)

func instant_day():
	is_day = true
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(world_light, "energy", 0, 1)
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
		if i == CurrentRun.world.current_level_info.level_parameters["distance"] -1:
			area = generate_event_area("level_complete", last_pos)
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

func _on_enemy_spawn_timer_timeout():
	enemy_spawn_timer.wait_time += .5
	spawn_level_enemies()
	CurrentRun.world.current_level_info.difficulty += .3
	enemy_spawn_timer.start()

func spawn_level_enemies():
	var spawn_count = CurrentRun.world.current_level_info.difficulty
	var new_spawner = EnemySpawner.new()
	add_child(new_spawner)
	
	var elite = roll_elite_enemy()
	
	#check if elite is spawning, if so spawn 1
	if elite:
		var random_enemy = new_spawner.find_random_enemy()
		while EnemyInfo.enemy_roster[random_enemy]["type"] == "thief":
			random_enemy = new_spawner.find_random_enemy()
		new_spawner.spawn_enemy(1, random_enemy, null, true)
	else:
		#spawn enemies by maximum allowed in EnemyInfo
		var random_enemy = new_spawner.find_random_enemy()
		var max_spawn = EnemyInfo.enemy_roster[random_enemy]["max_spawn"]
		new_spawner.spawn_enemy(clamp(spawn_count, 1, max_spawn), random_enemy, null, false)

func roll_elite_enemy():
	var rng = randi_range(1,50)
	if rng < CurrentRun.world.current_level_info.difficulty:
		return true
	else:
		return false

func handle_level_up():
	$LevelUpSFX.play()
	level_up_button.scale = Vector2(1.2, 1.2)
	level_up_button.disabled = false
	level_up_button.show()
	var tween = create_tween()
	tween.tween_property(level_up_button, "scale", Vector2(1, 1), .2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)

func level_up_button_pressed():
	if CurrentRun.world.current_player_info.level_up_queue > 0:
		CurrentRun.world.current_player_info.level_up_queue = clamp(CurrentRun.world.current_player_info.level_up_queue -1, 0, 100)
		
		level_up_button.disabled = true
		level_up_button.hide()
		
		populate_edge_menu()
		edge_menu.set_position(Vector2(0, -2000))
		CurrentRun.world.current_level_info.active_level.edge_menu.show()

		var pos_tween = create_tween()
		pos_tween.tween_property(edge_menu, "position", Vector2.ZERO, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
		await pos_tween.finished

		$EdgeSFX.play()
		pause_game()

# Edge Menu
func populate_edge_menu():
	var chosen_edges: Array = []
	for i in 3:
		var new_panel = edge_panel.instantiate()
		edge_menu.add_child(new_panel)
		
		var random_edge = EdgeInfo.edge_roster.keys().pick_random()
		while chosen_edges.has(random_edge):
			random_edge = EdgeInfo.edge_roster.keys().pick_random()
		
		chosen_edges.append(random_edge)
		new_panel.populate(random_edge)
		new_panel.clicked.connect(edge_selected)

func edge_selected(edge):
	new_player.edge_handler.add_edge(edge)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(edge_menu, "modulate", Color.TRANSPARENT, .2)
	await tween.finished
	CurrentRun.world.current_level_info.active_level.edge_menu.hide()
	for i in edge_menu.get_children():
		i.queue_free()
	edge_menu.modulate = Color.WHITE
	unpause_game()
	CurrentRun.world.current_player_info.state = "default"
	
	if CurrentRun.world.current_player_info.level_up_queue > 0:
		handle_level_up()

func weapon_picked_up(weapon, type):
	var container = $UI/WeaponMarginContainer
	var current_weapon_panel = $UI/WeaponMarginContainer/BG/GridContainer/CurrentWeaponPanel
	var new_weapon_panel = $UI/WeaponMarginContainer/BG/GridContainer/NewWeaponPanel
	container.position.y = -1080
	
	match type:
		"weapon":
			current_weapon_panel.populate()
			new_weapon_panel.populate(weapon)
		"charge_attack":
			current_weapon_panel.populate_charge_attack()
			new_weapon_panel.populate_charge_attack(weapon)
	
	container.show()
	var tween = create_tween()
	tween.tween_property(container, "position", Vector2.ZERO, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	$EdgeSFX.play()
	await tween.finished
	pause_game()

func keep_current_weapon():
	close_weapon_menu()

func equip_new_weapon(type, weapon, random_damage, random_attack_delay, random_projectile_speed):
	close_weapon_menu()
	
	match type:
		"weapon":
			CurrentRun.world.current_player_info.active_player._instantiate_ranged_weapon(\
				WeaponInfo.weapons_roster[weapon]["scene"], random_damage, random_attack_delay, random_projectile_speed)
			
			CurrentRun.world.current_player_info.current_ranged_weapon_reference = weapon
			CurrentRun.world.current_player_info.current_ranged_weapon_damage_mod = random_damage
			CurrentRun.world.current_player_info.current_ranged_weapon_attack_delay_mod = random_attack_delay
			CurrentRun.world.current_player_info.current_ranged_weapon_speed_mod = random_projectile_speed
		"charge_attack":
			CurrentRun.world.current_player_info.active_player._instantiate_charge_attack(WeaponInfo.charge_attacks_roster[weapon]["scene"])

func close_weapon_menu():
	unpause_game()
	var container = $UI/WeaponMarginContainer
	$UI/WeaponMarginContainer/WeaponSelectSFX.play()
	var tween = create_tween()
	tween.tween_property(container, "position", Vector2(0,-1080), .5).set_ease(Tween.EASE_OUT)
	await tween.finished
	container.hide()

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
