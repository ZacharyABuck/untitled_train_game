extends Node

# Experience Variables
var currentExperience: int = 0
var currentLevel: int = 1
var nextLevelExperience: int = 10
var totalExperience: int = 0

# Base Variables
var base_money: int = 15
var active_player
var base_max_health = 50
var animation
var base_ranged_damage_multiplier: float = 1.0
var base_melee_damage_multiplier: float = 1.0
var base_ranged_damage_bonus: int = 0
var base_melee_damage_bonus: int = 0
var base_movespeed: int = 300
var base_armor: int = 0
var base_attack_delay_modifier: float = 1.0

# Current Variables
var current_health: int
var current_max_health: int
var current_money: int
var current_ranged_damage_multiplier: float
var current_melee_damage_multiplier: float
var current_ranged_damage_bonus: int
var current_melee_damage_bonus: int
var current_movespeed: int
var current_armor: int
var current_attack_delay_modifier: float


func _ready():
	ExperienceSystem.give_experience.connect(self.handle_give_experience_signal)
	set_current_variables_to_base_value()

func set_current_variables_to_base_value():
	current_ranged_damage_multiplier = base_ranged_damage_multiplier
	current_melee_damage_multiplier = base_melee_damage_multiplier
	current_ranged_damage_bonus = base_ranged_damage_bonus
	current_melee_damage_bonus = base_melee_damage_bonus
	current_health = base_max_health
	current_max_health = base_max_health
	current_money = base_money
	current_armor = base_armor
	current_attack_delay_modifier = base_attack_delay_modifier
	current_movespeed = base_movespeed

# --EXPERIENCE FUNCTIONS-- #
func handle_give_experience_signal(value):
	currentExperience += value
	totalExperience += value
	if currentExperience >= nextLevelExperience:
		currentExperience = 0 + (currentExperience - nextLevelExperience)
		nextLevelExperience = nextLevelExperience*2
		currentLevel += 1
		ExperienceSystem.level_up.emit()
