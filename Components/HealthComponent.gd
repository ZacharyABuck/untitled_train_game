extends Node2D
class_name HealthComponent
# We initialize MAX_HEALTH at 10 as a default, but this can be changed in the Inspector.
# I'm not sure if we'll use the HealthComponent or the Rosters to set character stats.
# We have both right now (EnemyInfo vs. HealthComponent)

@export var MAX_HEALTH := 10
@export var ARMOR_VALUE := 0
@export var IS_KILLABLE := true
@export var ANIMATION : AnimatedSprite2D
@export var HEALTHBAR : ProgressBar

var health
var armor : int
var final_damage : int
var is_killable : bool
var has_healthbar : bool
var character
var animation
var healthbar = false


func _ready():
	health = MAX_HEALTH
	armor = ARMOR_VALUE
	is_killable = IS_KILLABLE
	animation = ANIMATION
	character = get_parent()
	if HEALTHBAR != null:
		_initialize_healthbar()
	
func damage(attack : Attack):
	_calculate_final_damage(attack.attack_damage, armor)
	if final_damage >= health:
		health = 0
	else:
		health -= final_damage
	if has_healthbar:
		healthbar.value = health
	if health <= 0:
		_handle_death()

func _handle_death():
	if is_killable:
		print(character.name, " killed.")
		if character.is_in_group("enemy"):
			PlayerInfo.money += character.money
			character.state = "dead"
			animation.play("death")

func _calculate_final_damage(damage, armor):
	final_damage = damage - armor
	if final_damage < 0:
		final_damage = 0
	return final_damage

func _initialize_healthbar():
		has_healthbar = true
		healthbar = HEALTHBAR
		healthbar.max_value = MAX_HEALTH
		healthbar.value = health
