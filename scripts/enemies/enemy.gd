extends RigidBody2D
class_name Enemy

@export_enum("moving", "boarding", "finish_boarding", "attacking", "idle", "dead") var state: String
@export var animations: AnimatedSprite2D
@export var health_component: HealthComponent
@export var projectile_attack_component: ProjectileAttackComponent
@export var attack_timer: Timer

var elite: bool = false
var enemy_stats: Dictionary
var speed: float
var money: float
var experience: float
var damage: float
var type: String

var target

func find_stats(enemy_type):
	enemy_stats = EnemyInfo.enemy_roster[enemy_type]
	type = enemy_stats["type"]
	speed = enemy_stats["speed"]
	money = enemy_stats["money"]
	experience = enemy_stats["experience"]
	damage = enemy_stats["damage"]
	health_component.health = enemy_stats["health"]
	
	if elite:
		upgrade_to_elite()

func upgrade_to_elite():
	animations.modulate = Color.HOT_PINK
	speed += EnemyInfo.elite_modifiers["speed"]
	health_component.health += EnemyInfo.elite_modifiers["health"]
	match type:
		"melee":
			damage += EnemyInfo.elite_modifiers["damage"]
		"ranged":
			if projectile_attack_component:
				projectile_attack_component.damage += EnemyInfo.elite_modifiers["damage"]

func shock(is_shocked):
	if is_shocked:
		speed = enemy_stats["speed"] * .3
	else:
		speed = enemy_stats["speed"]
		if elite:
			speed += EnemyInfo.elite_modifiers["speed"]
