# A Character needs a HealthComponent, a HurtboxComponent, and a Collision for the Hurtbox.
# The Animation you give the HealthComponent needs the following animations:
# 1. "death" -- what happens when the character is killed. This is only used if IsKillable is true.
# -----
# The ProgressBar is optional if you want the character to have an HP Bar to display. 
# The "character" for the HealthComponent is always the Parent Node of the Component.
# You can set multiple HealthComponents for a single character, if they have multiple Hurtboxes.
# If the character is an Enemy, they need to have a "state" variable and "money" variable for rewards.
# If we add XP, we'll need that variable as well.

extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : float
@export var ARMOR_VALUE : float = 0.0
@export var IS_KILLABLE := true
@export var ANIMATION : AnimatedSprite2D
@export var HEALTHBAR : ProgressBar

var money = preload("res://scenes/money.tscn")

var health : float
var armor : float
var final_damage : float
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
		if character.is_in_group("enemy"):
			LevelInfo.spawn_money(character.global_position, character.money)
			ExperienceSystem.give_experience.emit(character.experience)
			character.state = "dead"
			animation.play("death")
		
		if character.is_in_group("event"):
			character.queue_free()
			character.event_finished()
		
		if character.is_in_group("gadget"):
			character.hard_point.gadget = null
			character.hard_point.radial_menu.show()
			character.queue_free()

func _calculate_final_damage(damage, armor):
	final_damage = damage - armor
	if final_damage < 0.0:
		final_damage = 0.0
	return final_damage

func _initialize_healthbar():
		has_healthbar = true
		healthbar = HEALTHBAR
		healthbar.max_value = MAX_HEALTH
		healthbar.value = health
