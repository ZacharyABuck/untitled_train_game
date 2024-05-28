extends Node2D
class_name Ranged_Weapon

@export var attack_delay_timer : Timer
@export var gunshot_sound : AudioStreamPlayer2D

@onready var player = PlayerInfo.active_player

# -- BASE WEAPON STATS -- #
var base_attack_delay: float = 1.0
var base_projectile_speed: int = 30
var base_damage: float = 0
var base_lifetime: float = 3.0
var can_shoot : bool = true
var base_bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")

# -- CURRENT WEAPON STATS -- #
var current_attack_delay: float
var current_projectile_speed: int
var current_damage: float
var current_lifetime: float
var current_bullet

func _ready():
	current_attack_delay = base_attack_delay
	current_projectile_speed = base_projectile_speed
	current_damage = base_damage
	current_lifetime = base_lifetime
	current_bullet = base_bullet
	attack_delay_timer.wait_time = current_attack_delay
	attack_delay_timer.timeout.connect(_on_attack_timer_timeout)

func _set_current_variables_and_connect_timer():
	current_attack_delay = base_attack_delay
	current_projectile_speed = base_projectile_speed
	current_damage = base_damage
	current_lifetime = base_lifetime
	current_bullet = base_bullet
	attack_delay_timer.wait_time = current_attack_delay
	attack_delay_timer.timeout.connect(_on_attack_timer_timeout)

func _process(_delta):
	pass

func shoot():
	if can_shoot:
		can_shoot = false
		gunshot_sound.play()
		var new_bullet = _build_bullet(current_bullet.instantiate())
		LevelInfo.active_level.bullets.add_child(new_bullet)
		attack_delay_timer.wait_time = current_attack_delay
		attack_delay_timer.start()

func _on_attack_timer_timeout():
	attack_delay_timer.stop()
	can_shoot = true
	if Input.is_action_pressed("shoot"):
		shoot()

func _build_bullet(b):
	b.global_position = PlayerInfo.active_player.global_position
	b.speed = current_projectile_speed
	b.damage = current_damage
	b.target = get_global_mouse_position()
	b.valid_hitbox_types = {"enemy":true, "player":false, "car":false, "cover":false, "terrain":true}
	b.lifetime = current_lifetime
	
	return b
