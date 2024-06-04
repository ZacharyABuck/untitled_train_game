extends Node2D

@onready var health_bar = $HealthBar
@onready var sprite = $Sprite2D

var hard_point

func _ready():
	hard_point = get_parent()
	if hard_point.location == "FrontLeft" or \
	hard_point.location == "FrontRight" or \
	hard_point.location == "BackLeft" or \
	hard_point.location == "BackRight":
		rotation_degrees += 90

func _on_health_bar_value_changed(value):
		if value >= health_bar.max_value:
			sprite.frame = 0
		elif value >= health_bar.max_value*.8:
			sprite.frame = 1
		elif value >= health_bar.max_value*.6:
			sprite.frame = 2
		elif value >= health_bar.max_value*.4:
			sprite.frame = 3
		elif value >= health_bar.max_value*.2:
			sprite.frame = 4
