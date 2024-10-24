extends CharacterBody2D
class_name Enemy

@export_enum("moving", "boarding", "finish_boarding", "attacking", "idle", "dead") var state: String
@export var animations: AnimatedSprite2D
@export var health_component: HealthComponent
@export var projectile_attack_component: ProjectileAttackComponent
@export var attack_timer: Timer
@export var enemy_reference: String

var enemy_stats: Dictionary
var speed: float
var money: float
var experience: float
var damage: float
var type: String

var shock_speed_multiplier: float = 0.0
var train_speed_mod: float = 0.0

var target

var wave_enemy: bool = false
var cars_reached: int = 0
var last_car: int

func _ready():
	find_stats(enemy_reference)
	last_car = CurrentRun.world.current_train_info.train_stats["car_count"] - 1

func _process(_delta):
	if enemy_stats.has("speed") and CurrentRun.world.current_train_info.train_engine:
		train_speed_mod = max(CurrentRun.world.current_train_info.train_engine.velocity, 0)
		speed = (enemy_stats["speed"] + (train_speed_mod*45)) - (shock_speed_multiplier*1000)

func find_stats(enemy_type):
	enemy_stats = EnemyInfo.enemy_roster[enemy_type]
	type = enemy_stats["type"]
	speed = enemy_stats["speed"]
	money = enemy_stats["money"]
	experience = enemy_stats["experience"] * CurrentRun.world.current_level_info.difficulty
	damage = enemy_stats["damage"]
	health_component.MAX_HEALTH = enemy_stats["health"] * CurrentRun.world.current_level_info.difficulty
	health_component.health = enemy_stats["health"] * CurrentRun.world.current_level_info.difficulty

func find_next_nav_point():
	if CurrentRun.world.current_train_info.cars_inventory.has(last_car - cars_reached):
		var target_car = CurrentRun.world.current_train_info.cars_inventory[last_car - cars_reached]["node"]
		var nav_point = target_car.enemy_nav_points.get_child(0)
		for i in target_car.enemy_nav_points.get_children():
			if global_position.distance_to(i.global_position) < global_position.distance_to(nav_point.global_position):
				nav_point = i
		

		return nav_point

func find_random_target():
	var rng = CurrentRun.world.current_player_info.targets.pick_random()
	return rng
