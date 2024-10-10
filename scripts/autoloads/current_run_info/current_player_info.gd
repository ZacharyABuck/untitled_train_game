extends Node2D

# Experience Variables
var currentExperience: int = 0
var currentLevel: int = 1
var nextLevelExperience: int = 10
var totalExperience: int = 0

# Base Variables
var base_money: int = 20
var base_scrap: int = 0
var active_player
#var base_max_health : float = 50
var animation
var base_ranged_damage_bonus: float = 0
var base_melee_damage_bonus: float = 0
var base_movespeed: int = 300
var base_armor: float = 0
var base_attack_delay_modifier: float = 1.0
var base_repair_rate: float = 0.02
var base_charge_recovery_rate: float = 3.0

# Current Variables
#var current_health: float
#var current_max_health: float
var current_money: int
var current_scrap: int
var current_ranged_weapon_reference: String
var current_charge_attack_reference: String
var current_ranged_damage_bonus: float
var current_melee_damage_bonus: float
var current_movespeed: float
var current_armor: float
var current_attack_delay_modifier: float
var current_repair_rate: float
var current_charge_recovery_rate: float

# Weapon Variables
var current_ranged_weapon_damage_mod: int
var current_ranged_weapon_attack_delay_mod: float
var current_ranged_weapon_speed_mod: int

# Edge Related
var poison_damage = 1
var fire_damage = 2
var ricochet_amount: int = 0

# Current state in player state machine node
@export_enum("default", "repairing", "ui_default", "ui_edge_selection") var state: String = "default"

var targets = []

func _ready():
	ExperienceSystem.give_experience.connect(self.handle_give_experience_signal)
	set_current_variables_to_base_value()

func set_current_variables_to_base_value():
	current_ranged_damage_bonus = base_ranged_damage_bonus
	current_melee_damage_bonus = base_melee_damage_bonus
	#current_health = base_max_health
	#current_max_health = base_max_health
	current_money = base_money
	current_scrap = base_scrap
	current_armor = base_armor
	current_attack_delay_modifier = base_attack_delay_modifier
	current_movespeed = base_movespeed
	current_repair_rate = base_repair_rate
	current_charge_recovery_rate = base_charge_recovery_rate

# --EXPERIENCE FUNCTIONS-- #
func handle_give_experience_signal(value):
	currentExperience += value
	totalExperience += value
	if currentExperience >= nextLevelExperience:
		currentExperience = 0 + (currentExperience - nextLevelExperience)
		nextLevelExperience = nextLevelExperience * 2
		currentLevel += 1
		ExperienceSystem.level_up.emit()
		level_up_queue += 1

var level_up_queue: int = 0

func find_random_weapon_stats() -> Array:
	var difficulty = CurrentRun.world.current_level_info.difficulty
	var random_damage = clamp(snappedf(randf_range(-1,difficulty*.5), .1), 1, 100)
	var random_attack_delay = snappedf(randf_range(-.2,.3), 0.1)
	var random_projectile_speed = randi_range(-50,50)
	return [random_damage, random_attack_delay, random_projectile_speed]

func equip_new_weapon(type, weapon, random_damage, random_attack_delay, random_projectile_speed):
	match type:
		"weapon":
			current_ranged_weapon_reference = weapon
			current_ranged_weapon_damage_mod = random_damage
			current_ranged_weapon_attack_delay_mod = random_attack_delay
			current_ranged_weapon_speed_mod = random_projectile_speed
			if active_player:
				active_player._instantiate_ranged_weapon(WeaponInfo.weapons_roster[weapon]["scene"], random_damage, random_attack_delay, random_projectile_speed)
				active_player.refresh_current_ranged_weapon_stats()
		"charge_attack":
			if active_player:
				active_player._instantiate_charge_attack(WeaponInfo.charge_attacks_roster[weapon]["scene"])
