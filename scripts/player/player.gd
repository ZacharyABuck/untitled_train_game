extends CharacterBody2D
class_name Player

@onready var sprite = $AnimatedSprite2D
@onready var shadow = $Shadow
@onready var edge_handler = $EdgeHandler
@onready var running_sfx = $RunningSFX
@onready var repair_sfx = $RepairSFX
@onready var camera = $Camera2D
@onready var lasso = $Lasso

var active_buffs: Dictionary

var charging: bool = false
var current_charge_attack
var charge_attack_bar

var can_shoot = true
var current_ranged_weapon

signal melee_attack_fired
signal dead

# -- BASE FUNCTIONS -- #
func _ready():
	CurrentRun.world.current_player_info.active_player = self
	camera.make_current()
	
	#pick random weapon
	var weapon
	if CurrentRun.world.current_player_info.current_ranged_weapon_reference.is_empty():
		weapon = "melee"
		CurrentRun.world.current_player_info.current_ranged_weapon_reference = weapon
		_instantiate_ranged_weapon(WeaponInfo.weapons_roster[weapon]["scene"], 0, 0, 0)
	else:
		weapon = CurrentRun.world.current_player_info.current_ranged_weapon_reference
		_instantiate_ranged_weapon(WeaponInfo.weapons_roster[weapon]["scene"], \
			CurrentRun.world.current_player_info.current_ranged_weapon_damage_mod, \
			CurrentRun.world.current_player_info.current_ranged_weapon_attack_delay_mod, \
			CurrentRun.world.current_player_info.current_ranged_weapon_speed_mod)

	ExperienceSystem.level_up.connect(self.handle_level_up)
	
	edge_handler.check_for_edges()

func _process(_delta):
	shadow.animation = sprite.animation
	shadow.rotation = sprite.global_rotation

# -- ATTACK FUNCTIONS -- #
func _shoot():
	current_ranged_weapon.shoot()
	if current_ranged_weapon.weapon_id == "melee":
		melee_attack_fired.emit()

func check_charge():
	if is_instance_valid(current_charge_attack) and charge_attack_bar.value >= charge_attack_bar.max_value:
		charging = true
		charge_attack_bar.value = 0
		current_charge_attack.initiate_charge()

# -- EQUIPMENT FUNCTIONS -- #
func _instantiate_ranged_weapon(gun_scene_location, random_damage, random_attack_delay, random_projectile_speed):
	# Clear the existing ranged weapon so we can load the new one.
	if is_instance_valid(current_ranged_weapon):
		WeaponInfo.detach_buffs(current_ranged_weapon.active_buffs, active_buffs)
		current_ranged_weapon.queue_free()

	var gun_scene = gun_scene_location
	current_ranged_weapon = gun_scene.instantiate()

	# Modify base weapon by flat bonus and multiplier of character.
	var damage = current_ranged_weapon.base_damage
	damage += CurrentRun.world.current_player_info.current_ranged_damage_bonus
	current_ranged_weapon.base_damage = damage
	
	current_ranged_weapon.random_damage_mod = random_damage
	current_ranged_weapon.random_attack_delay_mod = random_attack_delay
	current_ranged_weapon.random_projectile_speed_mod = random_projectile_speed
	CurrentRun.world.current_player_info.current_ranged_weapon_reference = current_ranged_weapon.weapon_id
	add_child(current_ranged_weapon)
	
	refresh_current_ranged_weapon_stats()

func refresh_current_ranged_weapon_stats():
	var damage = current_ranged_weapon.base_damage
	WeaponInfo.attach_buffs(current_ranged_weapon.active_buffs, active_buffs)
	damage += CurrentRun.world.current_player_info.current_ranged_damage_bonus + CurrentRun.world.current_player_info.current_ranged_weapon_damage_mod
	current_ranged_weapon.current_damage = damage
	current_ranged_weapon.current_attack_delay = current_ranged_weapon.base_attack_delay * CurrentRun.world.current_player_info.current_attack_delay_modifier

# -- MOVEMENT FUNCTIONS -- #
func _on_car_detector_area_entered(area):
	if area.get_parent().is_in_group("car"):
		call_deferred("reparent", area.get_parent())

# -- EDGE AND LEVEL FUNCTIONS -- #

func handle_level_up():
	refresh_current_ranged_weapon_stats()
