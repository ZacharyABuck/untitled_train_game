extends RigidBody2D


@onready var attack_timer = $AttackTimer
@onready var animations = $AnimatedSprite2D
@onready var gun = $GunAttackComponent

var basic_bullet = preload("res://scenes/projectiles/basic_bullet.tscn")


var enemy_stats = EnemyInfo.enemy_roster["bandit"]
var speed = enemy_stats["speed"]
var health = enemy_stats["health"]
var damage = enemy_stats["damage"]
var money = enemy_stats["money"]

var target
var state = "moving"

func _ready():
	#var random_target = TrainInfo.cars_inventory.keys().pick_random()
	#target = TrainInfo.cars_inventory[random_target]["node"]
	#print("Bandit target: ", target.name)
	target = PlayerInfo.active_player

func _process(_delta):
	pass

func _physics_process(delta):
	if state != "dead":
		if gun.target_is_in_range(target):
			state = "attacking"
			gun.shoot_if_target_in_range(target)
		else:
			state = "moving"
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
	else:
		queue_free()
