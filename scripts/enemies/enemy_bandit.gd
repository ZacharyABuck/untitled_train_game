extends RigidBody2D

@onready var attack_timer = $AttackTimer
@onready var animations = $AnimatedSprite2D
@onready var gun = $GunAttackComponent

var enemy_stats = EnemyInfo.enemy_roster["bandit"]
var speed = enemy_stats["speed"]
var money = enemy_stats["money"]
var experience = enemy_stats["experience"]

var target
@onready var moving_target_component = $MovingTargetComponent


@export_enum("moving", "boarding", "attacking", "idle", "dead") var state: String

func _ready():
	target = PlayerInfo.active_player

func _physics_process(delta):
	moving_target_component.move_target(target.global_position, global_position, target.velocity, gun.BULLET_SPEED)
	if state != "dead":
		look_at(moving_target_component.global_position)
		if gun.target_is_in_range(moving_target_component):
			state = "attacking"
			gun.shoot_if_target_in_range(moving_target_component)
		else:
			state = "moving"
			move_and_collide(global_position.direction_to(moving_target_component.global_position)*(speed*delta))
	else:
		queue_free()
