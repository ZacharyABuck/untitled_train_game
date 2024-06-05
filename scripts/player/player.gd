extends CharacterBody2D
class_name Player

@onready var sprite = $AnimatedSprite2D
@onready var auto_fire_timer = $AutoFireTimer
@onready var hurtbox_component = $HurtboxComponent
@onready var health_bar = $HealthBar
@onready var health_component = $HealthComponent
@onready var edge_handler = $EdgeHandler
@onready var running_sfx = $RunningSFX
@onready var repair_sfx = $RepairSFX
@onready var camera = $Camera2D


var active_car

var can_shoot = true
var current_ranged_weapon

var repair_rate: float = 0.01

signal dead

#Many functions have been moved to the StateMachine. 
##Each child of Statemachine has the relevant behavior for that state.
##PlayerInfo contains the different state options

# -- BASE FUNCTIONS -- #
func _ready():
	PlayerInfo.active_player = self
	PlayerInfo.targets.append(self)
	camera.make_current()
	health_component.MAX_HEALTH = PlayerInfo.base_max_health
	health_component.ARMOR_VALUE = PlayerInfo.base_armor
	
	var weapon
	if PlayerInfo.current_ranged_weapon_reference.is_empty():
		weapon = WeaponInfo.weapons_roster.keys().pick_random()
		PlayerInfo.current_ranged_weapon_reference = weapon
	else:
		weapon = PlayerInfo.current_ranged_weapon_reference
	_instantiate_ranged_weapon(WeaponInfo.weapons_roster[weapon]["scene"])

	ExperienceSystem.level_up.connect(self.handle_level_up)
	
	edge_handler.check_for_edges()

# -- ATTACK FUNCTIONS -- #
func _shoot():
	current_ranged_weapon.shoot()

func _strike():
	# current_melee_weapon.strike()
	pass

# -- REPAIR -- #
func repair():
	if TrainInfo.cars_inventory[active_car]["node"].health < TrainInfo.cars_inventory[active_car]["node"].max_health:
		TrainInfo.cars_inventory[active_car]["node"].repair(repair_rate)
		sprite.play("repairing")
		if !repair_sfx.playing:
			repair_sfx.play()

# -- EDGE FUNCTIONS -- #
func player_hurt(damage):
	#check for shadowstep
	if EdgeInfo.edge_inventory.has("shadowstep"):
		var shadowstep_scene = EdgeInfo.edge_inventory["shadowstep"]["scene"]
		shadowstep_scene.enable_shadow()
		
	PlayerInfo.current_health -= damage
	if PlayerInfo.current_health < 0:
		dead.emit()


# -- EQUIPMENT FUNCTIONS -- #
func _instantiate_ranged_weapon(gun_scene_location):
	# Clear the existing ranged weapon so we can load the new one.
	if is_instance_valid(current_ranged_weapon):
		current_ranged_weapon.queue_free()

	var gun_scene = gun_scene_location
	current_ranged_weapon = gun_scene.instantiate()

	# Modify base weapon by flat bonus and multiplier of character.
	var damage = current_ranged_weapon.base_damage
	damage += PlayerInfo.current_ranged_damage_bonus
	damage *= PlayerInfo.current_ranged_damage_multiplier
	current_ranged_weapon.base_damage = damage
	add_child(current_ranged_weapon)

func refresh_current_ranged_weapon_stats():
	var damage = current_ranged_weapon.base_damage
	damage += PlayerInfo.current_ranged_damage_bonus
	damage *= PlayerInfo.current_ranged_damage_multiplier
	current_ranged_weapon.current_damage = damage
	current_ranged_weapon.current_attack_delay = current_ranged_weapon.base_attack_delay * PlayerInfo.current_attack_delay_modifier

# -- MOVEMENT FUNCTIONS -- #
func _on_car_detector_area_entered(area):
	if area.get_parent().is_in_group("car"):
		active_car = area.get_parent().index
		TrainInfo.cars_inventory[active_car]["node"].sprite.modulate = Color.WHITE
		call_deferred("reparent", TrainInfo.cars_inventory[active_car]["node"])
		for i in TrainInfo.cars_inventory:
			if i != active_car:
				TrainInfo.cars_inventory[i]["node"].sprite.modulate = TrainInfo.cars_inventory[i]["node"].starting_color

func _on_car_detector_area_exited(area):
	if area.get_parent().is_in_group("car"):
		TrainInfo.cars_inventory[active_car]["node"].sprite.modulate = TrainInfo.cars_inventory[active_car]["node"].starting_color

# -- EDGE AND LEVEL FUNCTIONS -- #

func handle_level_up():
	refresh_current_ranged_weapon_stats()
