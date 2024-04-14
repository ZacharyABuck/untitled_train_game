extends Node

var active_player
var max_health = 50
var health = 50
var money = 5
var currentExperience: int = 0
var currentLevel: int = 1
var nextLevelExperience: int = 10
var totalExperience: int = 0
var animation
var base_ranged_damage: int = 2
var base_melee_damage: int = 5
var ranged_damage: int
var melee_damage: int

func _ready():
	ExperienceSystem.give_experience.connect(self.handle_give_experience_signal)
	ranged_damage = base_ranged_damage
	melee_damage = base_melee_damage

func handle_give_experience_signal(value):
	currentExperience += value
	totalExperience += value
	if currentExperience >= nextLevelExperience:
		currentExperience = 0 + (currentExperience - nextLevelExperience)
		nextLevelExperience = nextLevelExperience*2
		currentLevel += 1
		ExperienceSystem.level_up.emit()
