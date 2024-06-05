extends Node

# Experience Variables
var currentExperience: int = 0
var currentLevel: int = 1
var nextLevelExperience: int = 10
var totalExperience: int = 0

# Base Variables
var base_money: int = 15
var active_player
var base_max_health : float = 50
var animation
var base_ranged_damage_multiplier: float = 1.0
var base_melee_damage_multiplier: float = 1.0
var base_ranged_damage_bonus: float = 0
var base_melee_damage_bonus: float = 0
var base_movespeed: int = 300
var base_armor: float = 0
var base_attack_delay_modifier: float = 1.0

# Current Variables
var current_health: float
var current_max_health: float
var current_money: int
var current_ranged_weapon_reference: String
var current_ranged_damage_multiplier: float
var current_melee_damage_multiplier: float
var current_ranged_damage_bonus: float
var current_melee_damage_bonus: float
var current_movespeed: float
var current_armor: float
var current_attack_delay_modifier: float

# Current state in player state machine node
@export_enum("default", "repairing", "ui_default", "ui_edge_selection") var state: String = "default"

var targets = []

func _ready():
	ExperienceSystem.give_experience.connect(self.handle_give_experience_signal)

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

func restart():
	if active_player:
		active_player.free()
	
	current_health = 0.0
	current_max_health = 0.0
	current_money = 0
	current_ranged_damage_multiplier = 0.0
	current_melee_damage_multiplier = 0.0
	current_ranged_damage_bonus = 0.0
	current_melee_damage_bonus = 0.0
	current_movespeed = 0.0
	current_armor = 0.0
	current_attack_delay_modifier = 0.0

	currentExperience = 0
	currentLevel = 1
	nextLevelExperience = 10
	totalExperience = 0
