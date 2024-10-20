extends Node2D

# Experience Variables
var current_experience: int = 0
var current_level: int = 1
var next_level_experience: int = 75
var total_experience: int = 0
var route_experience: int = 0

# Base Variables
var base_money: float = 20.00
var active_player
var animation
var base_ranged_damage_bonus: float = 0
var base_melee_damage_bonus: float = 0
var base_movespeed: int = 300
var base_armor: float = 0
var base_attack_delay_modifier: float = 1.0
var base_charge_recovery_rate: float = 3.0

# Current Variables
var current_money: float
var current_ranged_weapon_reference: String
var current_charge_attack_reference: String
var current_ranged_damage_bonus: float
var current_melee_damage_bonus: float
var current_movespeed: float
var current_armor: float
var current_attack_delay_modifier: float
var current_charge_recovery_rate: float

# Weapon Variables
var current_ranged_weapon_damage_mod: int
var current_ranged_weapon_attack_delay_mod: float
var current_ranged_weapon_speed_mod: int
var current_ranged_weapon_ammo_count: int

# Edge Related
var poison_damage = 0.5
var fire_damage = 1
var ricochet_amount: int = 0

# Current state in player state machine node
@export_enum("default", "lassoing", "ui_default", "ui_edge_selection") var state: String = "default"

var targets = []

func _ready():
	ExperienceSystem.give_experience.connect(self.handle_give_experience_signal)
	set_current_variables_to_base_value()

func set_current_variables_to_base_value():
	current_ranged_damage_bonus = base_ranged_damage_bonus
	current_melee_damage_bonus = base_melee_damage_bonus
	current_money = base_money
	current_armor = base_armor
	current_attack_delay_modifier = base_attack_delay_modifier
	current_movespeed = base_movespeed
	current_charge_recovery_rate = base_charge_recovery_rate

# --EXPERIENCE FUNCTIONS-- #
func handle_give_experience_signal(value):
	route_experience += value
	total_experience += value

func end_of_route_xp():
	current_experience += route_experience

func has_leveled_up():
	if current_experience >= next_level_experience:
		current_experience = 0 + (current_experience - next_level_experience)
		next_level_experience = next_level_experience * 2
		current_level += 1
		return true
	else:
		return false

func find_random_weapon_stats() -> Array:
	var difficulty = CurrentRun.world.current_level_info.difficulty
	var random_damage = clamp(snappedf(randf_range(-1,difficulty), .1), 1, 100)
	var random_attack_delay = snappedf(randf_range(-.2,.3), 0.1)
	var random_projectile_speed = randi_range(-50,50)
	return [random_damage, random_attack_delay, random_projectile_speed]

func equip_new_weapon(weapon, ammo_count, random_damage, random_attack_delay, random_projectile_speed):
	current_ranged_weapon_reference = weapon
	current_ranged_weapon_damage_mod = random_damage
	current_ranged_weapon_attack_delay_mod = random_attack_delay
	current_ranged_weapon_speed_mod = random_projectile_speed
	current_ranged_weapon_ammo_count = ammo_count
	if active_player:
		active_player._instantiate_ranged_weapon(WeaponInfo.weapons_roster[weapon]["scene"], random_damage, random_attack_delay, random_projectile_speed)
		active_player.refresh_current_ranged_weapon_stats()
	CurrentRun.world.current_level_info.active_level.set_weapon_label(weapon, ammo_count)

