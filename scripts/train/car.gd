extends Node2D

@onready var top_collider = $TopWall/CollisionShape2D
@onready var bottom_collider = $BottomWall/CollisionShape2D
@onready var sprite = $Sprite2D
@onready var health_bar = $HealthBar
@onready var hard_points = $HardPoints

@onready var room_light = $RoomLight
@onready var boarding_points = $BoardingPoints
@onready var boarding_sfx = $BoardingSFX

#CORNER POINTS FOR MESH
@onready var top_left = $CornerPoints/TopLeft
@onready var top_right = $CornerPoints/TopRight
@onready var bottom_left = $CornerPoints/BottomLeft
@onready var bottom_right = $CornerPoints/BottomRight
@onready var top_center = $CornerPoints/TopCenter

@onready var cargo_container = $CargoContainer

@onready var character_spawn_point = $CharacterSpawnPoint

var character = preload("res://scenes/characters/character.tscn")
var cargo = preload("res://scenes/train/cargo.tscn")
var hard_point = preload("res://scenes/train/hard_point.tscn")

var active_buffs: Array = []
var gadgets: Array = []

var max_health: float
var health: float
var armor: float = 0

var index
var type

var target

var starting_color

var cargo_count: int

func _ready():
	starting_color = $Sprite2D.modulate
	
	max_health = CurrentRun.world.current_train_info.train_stats["car_health"]
	health_bar.max_value = max_health
	health = max_health

func _process(_delta):
	health_bar.value = health
	
	if CurrentRun.world.current_level_info.active_level.world_light.energy >= .25 and room_light.enabled == false:
		room_light.enabled = true
	if CurrentRun.world.current_level_info.active_level.world_light.energy <= .25 and room_light.enabled == true:
		room_light.enabled = false

func check_for_gadgets():
	for gadget in CurrentRun.world.current_train_info.cars_inventory[index]["gadgets"].keys():
		for hardpoint in hard_points.get_children():
			if hardpoint.name == gadget:
				hardpoint.get_child(0).respawn_gadget(CurrentRun.world.current_train_info.cars_inventory[index]["gadgets"][gadget])

func take_damage(amount):
	health = clamp(health-clamp(amount-armor,0,amount), 0, max_health)

func repair(amount):
	health = clamp(health+amount, 0, max_health)

func set_parameters():
	if TrainInfo.cars_roster.has(type):
		sprite.texture = TrainInfo.cars_roster[type]["sprite"]
		spawn_hard_points()
	else:
		sprite.texture = load("res://sprites/train/temp_car.png")

func spawn_hard_points():
	for i in hard_points.get_children():
		if TrainInfo.cars_roster[type]["possible_hard_points"].has(str(i.name)):
			var new_hard_point = hard_point.instantiate()
			i.add_child(new_hard_point)
			i.get_child(0).sprite.texture = TrainInfo.hard_point_icon
			CurrentRun.world.current_train_info.cars_inventory[index]["hard_points"][i.name] = new_hard_point
			new_hard_point.location = i.name
			new_hard_point.car = self
		else:
			i.queue_free()

func hide_radial_menus():
	for i in hard_points.get_children():
		if i.get_child(0).radial_menu != null:
			i.get_child(0).radial_menu.close_menu()

func spawn_characters():
	for i in CurrentRun.world.current_mission_info.mission_inventory:
		if CurrentRun.world.current_mission_info.mission_inventory[i]["type"] == "escort":
			var new_character = character.instantiate()
			new_character.character_name = CurrentRun.world.current_mission_info.mission_inventory[i]["character"]
			new_character.position = character_spawn_point.position + Vector2(randi_range(-25,25),randi_range(-100,100))
			add_child(new_character)
			CurrentRun.world.current_player_info.targets.append(new_character)

func spawn_cargo():
	for i in CurrentRun.world.current_mission_info.mission_inventory.keys():
		if CurrentRun.world.current_mission_info.mission_inventory[i]["type"] == "delivery":
			var new_cargo_count = randi_range(1,3)
			cargo_container.cargo_count[i] = new_cargo_count
			for c in new_cargo_count:
				var new_cargo = cargo.instantiate()
				cargo_container.add_child(new_cargo)
				var random_pos = boarding_points.get_children().pick_random().global_position
				var random_pos_mods = [-25,25]
				new_cargo.global_position = Vector2(random_pos.x + random_pos_mods.pick_random(), random_pos.y)
				new_cargo.mission = i
				CurrentRun.world.current_player_info.targets.append(new_cargo)

