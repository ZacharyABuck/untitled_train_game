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

@export var status_effect_component: Node2D

var money = preload("res://scenes/money.tscn")
var blood_fx = preload("res://scenes/fx/blood_fx.tscn")

var health : float
#var armor : float
var final_damage : float
var is_killable : bool
var has_healthbar : bool
var character
var animation
var healthbar = false

signal fill_charge_meter

func _ready():
	#set armor?
	is_killable = IS_KILLABLE
	animation = ANIMATION
	character = get_parent()
	if character is Player:
		health = CurrentRun.world.current_player_info.current_health
		HEALTHBAR = CurrentRun.world.current_level_info.active_level.player_health_bar
	else:
		health = MAX_HEALTH
	if HEALTHBAR != null:
		_initialize_healthbar()
	
func damage(attack : Attack, shooter):
	_calculate_final_damage(attack.attack_damage, ARMOR_VALUE)
	
	health -= clamp(final_damage, 1, MAX_HEALTH)
	
	if character is Player:
		character.player_hurt(final_damage)
	
	if has_healthbar:
		healthbar.value = health
	if health <= 0:
		_handle_death(shooter)

func process_buffs(buff):
	if status_effect_component:
		status_effect_component.health_component = self
		match buff:
			"poison":
				status_effect_component.apply_poison()
			"shock":
				status_effect_component.apply_shock()
			"fire":
				status_effect_component.apply_fire()

func spawn_particles(fx):
	var new_fx = fx.instantiate()
	CurrentRun.world.current_level_info.active_level.add_child(new_fx)
	new_fx.global_position = character.global_position
	new_fx.emitting = true

func _handle_death(shooter):
	if is_killable:
		if character.is_in_group("enemy"):
			var rng = randi_range(-4,2)
			CurrentRun.world.current_level_info.spawn_money(character.global_position, clamp(character.money+rng,0,int(CurrentRun.world.current_level_info.difficulty)))
			ExperienceSystem.give_experience.emit(character.experience)
			CurrentRun.world.current_level_info.active_level.enemy_killed()
			character.state = "dead"
			animation.play("death")
			if character is RigidBody2D:
				character.set_collision_layer_value(4, false)
				character.set_collision_mask_value(4, false)
			check_edges(shooter)
		
		if character.is_in_group("event"):
			character.queue_free()
			character.event_finished()
		if character.is_in_group("hazard"):
			character.hazard_cleared.emit()
			character.queue_free()
		
		if character.is_in_group("gadget"):
			character.hard_point.gadget = null
			character.hard_point.radial_menu.update_menu("default")
			character.hard_point.radial_menu.show()
			character.hard_point.car.armor -= clamp(2, 0, 10)
			
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

#check for edges that trigger on kills
func check_edges(shooter):
	for edge in CurrentRun.world.current_edge_info.edge_inventory:
		var edge_scene = CurrentRun.world.current_edge_info.edge_inventory[edge]["scene"]
		if edge == "turret_kills_fill_charge" and shooter is Turret:
			edge_scene.fill_meter()
		if edge == "player_kills_fill_charge" and shooter is Player:
			edge_scene.fill_meter()

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


