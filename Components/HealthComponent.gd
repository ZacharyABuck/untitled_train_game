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
var blood_fx = preload("res://scenes/fx/blood_fx.tscn")
var poison_fx = preload("res://scenes/fx/poison_fx.tscn")

var health : float
#var armor : float
var final_damage : float
var is_killable : bool
var has_healthbar : bool
var character
var animation
var healthbar = false

@onready var poison_timer = $PoisonTimer



func _ready():
	#set armor?
	is_killable = IS_KILLABLE
	animation = ANIMATION
	character = get_parent()
	if character is Player:
		health = CurrentRun.world.current_player_info.current_health
	else:
		health = MAX_HEALTH
	if HEALTHBAR != null:
		_initialize_healthbar()
	
func damage(attack : Attack):
	_calculate_final_damage(attack.attack_damage, ARMOR_VALUE)
	
	health -= clamp(final_damage, 1, MAX_HEALTH)
	
	if character is Player:
		character.player_hurt(final_damage)
	
	if has_healthbar:
		healthbar.value = health
	if health <= 0:
		_handle_death()

func process_buffs(buff):
	match buff:
		"poison":
			if poison_timer.is_stopped():
				poison_timer.start()

func _on_poison_timer_timeout():
	var poison_damage = CurrentRun.world.current_player_info.poison_damage
	var poison_tick = Attack.new()
	poison_tick.attack_damage = poison_damage
	damage(poison_tick)
	spawn_particles(poison_fx)
	get_parent().modulate = Color.WEB_GREEN

func spawn_particles(fx):
	var new_fx = fx.instantiate()
	CurrentRun.world.current_level_info.active_level.add_child(new_fx)
	new_fx.global_position = character.global_position
	new_fx.emitting = true

func _handle_death():
	if is_killable:
		if character.is_in_group("enemy"):
			var rng = randi_range(1,10)
			if rng > 5:
				CurrentRun.world.current_level_info.spawn_money(character.global_position, character.money)
			ExperienceSystem.give_experience.emit(character.experience)
			character.state = "dead"
			animation.play("death")
			if character is RigidBody2D:
				character.set_collision_layer_value(4, false)
				character.set_collision_mask_value(4, false)
		
		if character.is_in_group("event"):
			character.queue_free()
			character.event_finished()
		
		if character.is_in_group("gadget"):
			character.hard_point.gadget = null
			character.hard_point.radial_menu.update_menu("gadgets")
			character.hard_point.radial_menu.show()
			character.queue_free()
		
		if character.is_in_group("character"):
			for i in CurrentRun.world.current_mission_info.mission_inventory:
				if CurrentRun.world.current_mission_info.mission_inventory[i]["character"] == character.character_name:
					print("Mission Failed: " + str(character.character_name) + " killed!")
					remove_mission(i)
					CurrentRun.world.current_player_info.targets.erase(i)
					character.queue_free()
		
		if character.is_in_group("cargo"):
			CurrentRun.world.current_player_info.targets.erase(character)
			for i in CurrentRun.world.current_mission_info.mission_inventory.keys():
				if i == character.mission:
					print("Cargo Destroyed!")
					if character.get_parent().destroyed_cargo.keys().has(i):
						character.get_parent().destroyed_cargo[i] += 1
					else:
						character.get_parent().destroyed_cargo[i] = 1
					var destroyed: int = character.get_parent().destroyed_cargo[i]
					var count: int = character.get_parent().cargo_count[i]
					if destroyed >= count:
						remove_mission(i)
						print("Mission Failed: Delivery")
					else:
						CurrentRun.world.current_mission_info.mission_inventory[i]["reward"] *= .75
					character.queue_free()

func remove_mission(mission_id):
	CurrentRun.world.current_mission_info.mission_inventory.erase(mission_id)
	for p in CurrentRun.world.mission_inventory_container.get_children():
		if p.mission_id == mission_id:
			p.queue_free()

func _calculate_final_damage(attacker_damage, armor):
	final_damage = attacker_damage - armor
	if final_damage < 0.0:
		final_damage = 0.5
	return final_damage

func _initialize_healthbar():
		has_healthbar = true
		healthbar = HEALTHBAR
		healthbar.max_value = MAX_HEALTH
		healthbar.value = health

