extends CharacterBody2D
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

var wave_enemy: bool = false
var cars_reached: int = 0


func _process(delta):
	if wave_enemy:
		if CurrentRun.world.current_train_info.train_stats["car_count"] != cars_reached:
			if target and global_position.distance_to(target.global_position) < 50:
				target = find_target()
				

func find_stats(enemy_type):
	enemy_stats = EnemyInfo.enemy_roster[enemy_type]
	type = enemy_stats["type"]
	speed = enemy_stats["speed"]
	money = enemy_stats["money"]
	experience = enemy_stats["experience"]
	damage = enemy_stats["damage"]
	health_component.health = enemy_stats["health"]

func find_target():
	var new_target
	if wave_enemy:
		var last_car = CurrentRun.world.current_train_info.train_stats["car_count"] - 1
		if last_car == cars_reached:
			new_target = find_random_target()
		else:
			cars_reached += 1
			new_target = find_next_nav_point()
	else:
		new_target = find_random_target()
	
	return new_target
		

func find_next_nav_point():
	var last_car = CurrentRun.world.current_train_info.train_stats["car_count"] - 1
	if CurrentRun.world.current_train_info.cars_inventory.has(last_car - cars_reached):
		var target_car = CurrentRun.world.current_train_info.cars_inventory[last_car - cars_reached]["node"]
		var nav_point = target_car.enemy_nav_points.get_child(0)
		for i in target_car.enemy_nav_points.get_children():
			if global_position.distance_to(i.global_position) < global_position.distance_to(nav_point.global_position):
				nav_point = i
		

		return nav_point

func find_random_target():
	if CurrentRun.world.current_train_info.furnace != null:
		return CurrentRun.world.current_train_info.furnace
	else:
		var rng = CurrentRun.world.current_player_info.targets.pick_random()
		while rng.is_in_group("cargo"):
			rng = CurrentRun.world.current_player_info.targets.pick_random()
		return rng
