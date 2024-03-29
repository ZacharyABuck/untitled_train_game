extends Node2D

@onready var top_collider = $TopWall/CollisionShape2D
@onready var bottom_collider = $BottomWall/CollisionShape2D
@onready var sprite = $Sprite2D
@onready var health_bar = $HealthBar
@onready var hard_points = $HardPoints
@onready var gadgets = $Gadgets


var hard_point = preload("res://scenes/hard_point.tscn")

var max_health = 20
var health = 20

var type

var starting_color

func _ready():
	starting_color = $Sprite2D.modulate
	health_bar.max_value = max_health
	health_bar.value = health

func take_damage(amount):
	health -= amount
	health_bar.value = health

func set_parameters():
	if TrainInfo.cars_roster.has(type):
		sprite.texture = TrainInfo.cars_roster[type]["sprite"]
		for i in hard_points.get_children():
			if TrainInfo.cars_roster[type]["hard_points"].has(str(i.name)):
				var new_hard_point = hard_point.instantiate()
				i.add_child(new_hard_point)
				i.get_child(0).sprite.texture = TrainInfo.hard_point_icon
			else:
				i.queue_free()
	else:
		sprite.texture = load("res://sprites/train/temp_car.png")
