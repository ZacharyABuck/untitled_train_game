extends RigidBody2D

@onready var attack_timer = $AttackTimer
@onready var animations = $AnimatedSprite2D
@onready var gun = $GunAttackComponent

var enemy_stats = EnemyInfo.enemy_roster["bandit"]
var speed = enemy_stats["speed"]
var money = enemy_stats["money"]
var experience = enemy_stats["experience"]

var target
@export_enum("moving", "boarding", "attacking", "idle", "dead") var state: String

func _ready():
	target = PlayerInfo.active_player

func _process(_delta):
	pass

func _physics_process(delta):
	if state != "dead":
		look_at(target.global_position)
		if gun.target_is_in_range(target):
			state = "attacking"
			gun.shoot_if_target_in_range(target)
		else:
			state = "moving"
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
	else:
		queue_free()
