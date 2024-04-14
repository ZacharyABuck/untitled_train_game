extends Node2D

@export var attack_delay_timer : Timer
@export var gunshot_sound : AudioStreamPlayer2D

@onready var player = PlayerInfo.active_player

# -- BASE WEAPON STATS -- #
var base_attack_delay: float = 1.0
var base_projectile_speed: int = 30
var base_damage: int = 2
var base_lifetime: float = 3.0
var can_shoot : bool = true
var base_bullet = preload("res://scenes/projectiles/fiery_bullet.tscn")

# -- CURRENT WEAPON STATS -- #
var current_attack_delay: float
var current_projectile_speed: int
var current_damage: int
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

func _process(delta):
	pass

func shoot():
	if can_shoot:
		gunshot_sound.play()
		var new_bullet = current_bullet.instantiate()
		new_bullet.global_position = PlayerInfo.active_player.global_position
		new_bullet.speed = current_projectile_speed
		new_bullet.damage = current_damage
		new_bullet.target = get_global_mouse_position()
		new_bullet.valid_hitbox_types = {"enemy":true, "player":false, "car":false, "terrain":true}
		LevelInfo.active_level.bullets.add_child(new_bullet)
		can_shoot = false
		attack_delay_timer.start()

func _on_attack_timer_timeout():
	attack_delay_timer.stop()
	can_shoot = true
	if Input.is_action_pressed("shoot"):
		shoot()


