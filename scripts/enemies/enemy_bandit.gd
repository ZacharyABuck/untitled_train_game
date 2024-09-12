extends RigidBody2D

@onready var attack_timer = $AttackTimer
@onready var animations = $AnimatedSprite2D
@onready var gun = $GunAttackComponent
@onready var health_component = $HealthComponent

var elite: bool = false
var enemy_stats = EnemyInfo.enemy_roster["bandit"]
var speed = enemy_stats["speed"]
var money = enemy_stats["money"]
var experience = enemy_stats["experience"]

var target

@export_enum("moving", "boarding", "attacking", "idle", "dead") var state: String

func _ready():
	target = CurrentRun.world.current_player_info.active_player
	if elite:
		upgrade()
#
#func find_target():
	#var rng = CurrentRun.world.current_player_info.targets.pick_random()
	#return rng

func upgrade():
	animations.modulate = Color.RED
	speed += EnemyInfo.elite_modifiers["speed"]
	gun.damage += EnemyInfo.elite_modifiers["damage"]
	health_component.health += EnemyInfo.elite_modifiers["health"]

func _physics_process(delta):
	if target == null:
		target = CurrentRun.world.current_player_info.active_player
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
