extends Node2D

@onready var top_collider = $TopWall/CollisionShape2D
@onready var bottom_collider = $BottomWall/CollisionShape2D
@onready var sprite = $Sprite2D
@onready var health_bar = $HealthBar
@onready var hard_points = $HardPoints
@onready var gadgets = $Gadgets
@onready var room_light = $RoomLight
@onready var boarding_points = $BoardingPoints
@onready var boarding_sfx = $BoardingSFX
#CORNER POINTS FOR MESH
@onready var top_left = $CornerPoints/TopLeft
@onready var top_right = $CornerPoints/TopRight
@onready var bottom_left = $CornerPoints/BottomLeft
@onready var bottom_right = $CornerPoints/BottomRight
@onready var top_center = $CornerPoints/TopCenter

var character = preload("res://scenes/characters/character.tscn")
var hard_point = preload("res://scenes/hard_point.tscn")

var max_health: float = 50.0
var health: float = 50.0

var index
var type

var target

var starting_color

func _ready():
	starting_color = $Sprite2D.modulate
	health_bar.max_value = max_health
	health_bar.value = health

func _process(_delta):
	health_bar.value = health
	
	if LevelInfo.active_level.world_light.energy >= .25 and room_light.enabled == false:
		room_light.enabled = true
	if LevelInfo.active_level.world_light.energy <= .25 and room_light.enabled == true:
		room_light.enabled = false

func check_for_gadgets():
	for gadget in TrainInfo.cars_inventory[index]["gadgets"].keys():
		for hardpoint in hard_points.get_children():
			if hardpoint.name == gadget:
				hardpoint.get_child(0).respawn_gadget(TrainInfo.cars_inventory[index]["gadgets"][gadget])

func take_damage(amount):
	health -= amount

func repair(amount):
	health += amount

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
			TrainInfo.cars_inventory[index]["hard_points"][i.name] = new_hard_point
			new_hard_point.location = i.name
			new_hard_point.car = self
		else:
			i.queue_free()

func hide_radial_menus():
	for i in hard_points.get_children():
		if i.get_child(0).radial_menu != null:
			i.get_child(0).radial_menu.close_menu()

func spawn_characters():
	await get_tree().create_timer(.5).timeout
	for i in MissionInfo.mission_inventory:
		if MissionInfo.mission_inventory[i]["character"] != null:
			var new_character = character.instantiate()
			new_character.character_name = MissionInfo.mission_inventory[i]["character"]
			new_character.position = $CharacterSpawnPoint.position + Vector2(randi_range(-25,25),randi_range(-75,75))
			add_child(new_character)
			PlayerInfo.targets.append(new_character)
