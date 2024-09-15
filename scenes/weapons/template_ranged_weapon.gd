extends Node2D
class_name Ranged_Weapon

@export var attack_delay_timer : Timer
@export var gunshot_sound : AudioStreamPlayer2D

@onready var player = CurrentRun.world.current_player_info.active_player

var weapon_id

# -- BASE WEAPON STATS -- #
var base_attack_delay: float
var base_projectile_speed: int
var base_damage: float
var base_lifetime: float
var can_shoot : bool = true
var base_bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")

# -- RANDOM MODS FROM DROPS -- #
var random_damage_mod: float = 0
var random_attack_delay_mod: float = 0
var random_projectile_speed_mod: float = 0

# -- CURRENT WEAPON STATS -- #
var current_attack_delay: float
var current_projectile_speed: int
var current_damage: float
var current_lifetime: float
var current_bullet

func _set_current_variables_and_connect_timer():
	current_attack_delay = (base_attack_delay + random_attack_delay_mod) * CurrentRun.world.current_player_info.current_attack_delay_modifier
	current_projectile_speed = base_projectile_speed + random_projectile_speed_mod
	current_damage = base_damage + random_damage_mod
	current_lifetime = base_lifetime
	current_bullet = base_bullet
	attack_delay_timer.wait_time = current_attack_delay
	attack_delay_timer.timeout.connect(_on_attack_timer_timeout)
	
	print(current_damage)

func _process(_delta):
	pass

func shoot():
	if can_shoot:
		can_shoot = false
		gunshot_sound.play()
		var new_bullet = _build_bullet(current_bullet.instantiate())
		CurrentRun.world.current_level_info.active_level.bullets.add_child(new_bullet)
		attack_delay_timer.wait_time = current_attack_delay
		attack_delay_timer.start()

func _on_attack_timer_timeout():
	attack_delay_timer.stop()
	can_shoot = true
	if Input.is_action_pressed("shoot"):
		shoot()

func _build_bullet(b):
	b.global_position = CurrentRun.world.current_player_info.active_player.global_position
	b.speed = current_projectile_speed
	b.damage = current_damage
	b.target = get_global_mouse_position()
	b.valid_hitbox_types = {"enemy":true, "player":false, "car":false, "cover":false, "terrain":true}
	b.lifetime = current_lifetime
	
	return b
