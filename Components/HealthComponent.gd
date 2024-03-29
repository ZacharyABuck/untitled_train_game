extends Node2D
class_name HealthComponent

# We initialize MAX_HEALTH at 10 as a default, but this can be changed in the Inspector.
@export var MAX_HEALTH := 10

var health : int

func _ready():
	health = MAX_HEALTH

func damage(attack : Attack):
	health -= attack.attack_damage
	if health <= 0:
		get_parent().queue_free()
