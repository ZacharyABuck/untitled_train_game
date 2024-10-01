extends CharacterBody2D
class_name Player

@onready var sprite = $AnimatedSprite2D
@onready var shadow = $Shadow
@onready var hurtbox_component = $HurtboxComponent
@onready var health_component = $HealthComponent
@onready var edge_handler = $EdgeHandler
@onready var running_sfx = $RunningSFX
@onready var repair_sfx = $RepairSFX
@onready var camera = $Camera2D
@onready var buff = $Buff


var active_car

var charging: bool = false
var current_charge_attack
var charge_attack_bar

var can_shoot = true
var current_ranged_weapon

signal dead

#Many functions have been moved to the StateMachine. 
##Each child of Statemachine has the relevant behavior for that state.
##CurrentRun.world.current_player_info contains the different state options

# -- BASE FUNCTIONS -- #
func _ready():
	CurrentRun.world.current_player_info.active_player = self
	CurrentRun.world.current_player_info.targets.append(self)
	camera.make_current()
	
	health_component.MAX_HEALTH = CurrentRun.world.current_player_info.current_max_health
	health_component.ARMOR_VALUE = CurrentRun.world.current_player_info.current_armor
	
	charge_attack_bar = CurrentRun.world.current_level_info.active_level.player_charge_bar
	
	#pick random weapon
	var weapon
	if CurrentRun.world.current_player_info.current_ranged_weapon_reference.is_empty():
		weapon = WeaponInfo.weapons_roster.keys().pick_random()
		CurrentRun.world.current_player_info.current_ranged_weapon_reference = weapon
		_instantiate_ranged_weapon(WeaponInfo.weapons_roster[weapon]["scene"], 0, 0, 0)
	else:
		weapon = CurrentRun.world.current_player_info.current_ranged_weapon_reference
		_instantiate_ranged_weapon(WeaponInfo.weapons_roster[weapon]["scene"], \
			CurrentRun.world.current_player_info.current_ranged_weapon_damage_mod, \
			CurrentRun.world.current_player_info.current_ranged_weapon_attack_delay_mod, \
			CurrentRun.world.current_player_info.current_ranged_weapon_speed_mod)
	
	#charge attack
	var charge_attack
	if CurrentRun.world.current_player_info.current_charge_attack_reference.is_empty():
		charge_attack = WeaponInfo.charge_attacks_roster.keys().pick_random()
		CurrentRun.world.current_player_info.current_charge_attack_reference = charge_attack
		_instantiate_charge_attack(WeaponInfo.charge_attacks_roster[charge_attack]["scene"])
	else:
		charge_attack = CurrentRun.world.current_player_info.current_charge_attack_reference
		_instantiate_charge_attack(WeaponInfo.charge_attacks_roster[charge_attack]["scene"])

	ExperienceSystem.level_up.connect(self.handle_level_up)
	
	edge_handler.check_for_edges()

func _process(_delta):
	shadow.animation = sprite.animation
	shadow.rotation = sprite.global_rotation

# -- ATTACK FUNCTIONS -- #
func _shoot():
	current_ranged_weapon.shoot()

func check_charge():
	if is_instance_valid(current_charge_attack) and charge_attack_bar.value >= charge_attack_bar.max_value:
		charging = true
		charge_attack_bar.value = 0
		current_charge_attack.initiate_charge()

# -- REPAIR -- #
func repair():
	if CurrentRun.world.current_train_info.cars_inventory[active_car]["node"].health < CurrentRun.world.current_train_info.cars_inventory[active_car]["node"].max_health:
		CurrentRun.world.current_train_info.cars_inventory[active_car]["node"].repair(CurrentRun.world.current_player_info.current_repair_rate)
		sprite.play("repairing")
		if !repair_sfx.playing:
			repair_sfx.play()

# -- EDGE FUNCTIONS -- #
func player_hurt(damage):
	#check for shadowstep
	if CurrentRun.world.current_edge_info.edge_inventory.has("shadowstep"):
		var shadowstep_scene = CurrentRun.world.current_edge_info.edge_inventory["shadowstep"]["scene"]
		shadowstep_scene.enable_shadow()
		
	CurrentRun.world.current_player_info.current_health -= damage
	if CurrentRun.world.current_player_info.current_health < 0:
		dead.emit()


# -- EQUIPMENT FUNCTIONS -- #
func _instantiate_ranged_weapon(gun_scene_location, random_damage, random_attack_delay, random_projectile_speed):
	# Clear the existing ranged weapon so we can load the new one.
	if is_instance_valid(current_ranged_weapon):
		current_ranged_weapon.queue_free()

	var gun_scene = gun_scene_location
	current_ranged_weapon = gun_scene.instantiate()

	# Modify base weapon by flat bonus and multiplier of character.
	var damage = current_ranged_weapon.base_damage
	damage += CurrentRun.world.current_player_info.current_ranged_damage_bonus
	damage *= CurrentRun.world.current_player_info.current_ranged_damage_multiplier
	current_ranged_weapon.base_damage = damage
	
	current_ranged_weapon.random_damage_mod = random_damage
	current_ranged_weapon.random_attack_delay_mod = random_attack_delay
	current_ranged_weapon.random_projectile_speed_mod = random_projectile_speed
	
	add_child(current_ranged_weapon)

func refresh_current_ranged_weapon_stats():
	var damage = current_ranged_weapon.base_damage
	damage += CurrentRun.world.current_player_info.current_ranged_damage_bonus + CurrentRun.world.current_player_info.current_ranged_weapon_damage_mod
	damage *= CurrentRun.world.current_player_info.current_ranged_damage_multiplier
	current_ranged_weapon.current_damage = damage
	current_ranged_weapon.current_attack_delay = current_ranged_weapon.base_attack_delay * CurrentRun.world.current_player_info.current_attack_delay_modifier

func _instantiate_charge_attack(charge_attack_scene):
	if is_instance_valid(current_charge_attack):
		current_charge_attack.queue_free()
		
	current_charge_attack = charge_attack_scene.instantiate()
	add_child(current_charge_attack)
	
	CurrentRun.world.current_player_info.current_charge_attack_reference = current_charge_attack.reference

# -- MOVEMENT FUNCTIONS -- #
func _on_car_detector_area_entered(area):
	if area.get_parent().is_in_group("car"):
		active_car = area.get_parent().index
		CurrentRun.world.current_train_info.cars_inventory[active_car]["node"].sprite.modulate = Color.WHITE
		call_deferred("reparent", CurrentRun.world.current_train_info.cars_inventory[active_car]["node"])
		for i in CurrentRun.world.current_train_info.cars_inventory:
			if i != active_car:
				CurrentRun.world.current_train_info.cars_inventory[i]["node"].sprite.modulate = CurrentRun.world.current_train_info.cars_inventory[i]["node"].starting_color

func _on_car_detector_area_exited(area):
	if area.get_parent().is_in_group("car"):
		CurrentRun.world.current_train_info.cars_inventory[active_car]["node"].sprite.modulate = CurrentRun.world.current_train_info.cars_inventory[active_car]["node"].starting_color

# -- EDGE AND LEVEL FUNCTIONS -- #

func handle_level_up():
	refresh_current_ranged_weapon_stats()

