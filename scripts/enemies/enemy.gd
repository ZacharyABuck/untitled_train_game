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

func find_target():
	#make sure target isn't cargo
	var rng = CurrentRun.world.current_player_info.targets.pick_random()
	while rng.is_in_group("cargo"):
		rng = CurrentRun.world.current_player_info.targets.pick_random()
	return rng

func upgrade_to_elite():
	#NEED TO UPDATE HOW ELITE LOOKS AND WORKS
	animations.modulate = Color.HOT_PINK
	speed += EnemyInfo.elite_modifiers["speed"]
	health_component.health += EnemyInfo.elite_modifiers["health"]
	match type:
		"melee":
			damage += EnemyInfo.elite_modifiers["damage"]
		"ranged":
			if projectile_attack_component:
				projectile_attack_component.damage += EnemyInfo.elite_modifiers["damage"]
