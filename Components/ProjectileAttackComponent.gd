# Configure a Projectile Attack with the below variables.
# This Component handles the logic for firing the projectile. You supply the projectile via the PackedScene.
# The TARGET_AREA is the area that the enemy uses to determine if a target is in range.
# The most common pattern is to use "target_is_in_range(target)" to determine when to kick off the attack.
# You can then use "shoot_at_target(target)" or "shoot_if_target_in_range(target)" to shoot.
# Projectile animations need a "hit" and a "travel" animation.
# The Projectile node type always has the requisite variables (from the template).

extends Area2D
class_name ProjectileAttackComponent

@export var TARGET_TYPES = {
	"player":false,
	"enemy":false,
	"car":false,
	"cover":false,
	"terrain":false
}
@export var ATTACK_TIMER := Timer
@export var BULLET_SPEED := 800
@export var DAMAGE_PER_BULLET : float = 2.0
@export var NUMBER_OF_BULLETS := 1 
@export var PROJECTILE : PackedScene # <--Must extend 'Projectile'
@export var MOBILE_ATTACK := false
@export var TARGET_AREA : CollisionShape2D
@export var LIFETIME := 3
@export var BUFF_RECEIVER : Area2D
@export var SHOOT_SOUND: AudioStreamPlayer2D

var attack_timer
var default_attack_time
var speed
var projectile
var damage
var number_of_bullets
var shooter
var type
var target_types
var mobile_attack
var attack_target
var lifetime
var shoot_sound

func _ready():
	attack_timer = ATTACK_TIMER
	default_attack_time = attack_timer.wait_time
	speed = BULLET_SPEED
	shoot_sound = SHOOT_SOUND
	projectile = PROJECTILE
	damage = DAMAGE_PER_BULLET
	number_of_bullets = NUMBER_OF_BULLETS
	shooter = get_parent()
	target_types = TARGET_TYPES
	lifetime = LIFETIME
	mobile_attack = MOBILE_ATTACK
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	_set_layers(self)

func shoot_if_target_in_range(target):
	attack_target = target
	if attack_timer.is_stopped():
		for i in get_overlapping_bodies():
			if i == attack_target:
				_shoot()
				break
		for i in get_overlapping_areas():
			if i == attack_target:
				_shoot()
				break

func shoot_at_target(target):
	attack_target = target
	# fire initially, then kick off timer.
	if attack_timer.is_stopped():
		_shoot()

func _shoot():
	if BUFF_RECEIVER:
		attack_timer.wait_time = max(.1, default_attack_time - BUFF_RECEIVER.attack_delay_bonus)
	
	attack_timer.start()
	if shoot_sound: shoot_sound.play()
	else: AudioSystem.play_audio_2d("gunshot", global_position, -15)
	var new_projectile = _instantiate_bullet()
	# Add the bullet to the parent scene of the shooter, which fires the projectile.
	CurrentRun.world.add_child(new_projectile)

func _instantiate_bullet():
	# Set core variables of Bullet. The Bullet needs to always have these variables.
	# speed, damage, global_position, valid_hitbox_types
	var new_projectile = projectile.instantiate()
	new_projectile.global_position = shooter.global_position
	
	#check for buffs
	if BUFF_RECEIVER != null:
		var car_buffs = owner.car.active_buffs
		for buff in car_buffs:
			if !BUFF_RECEIVER.active_buffs.has(buff):
				BUFF_RECEIVER.active_buffs.append(buff)
		new_projectile.active_buffs = BUFF_RECEIVER.active_buffs
	
	new_projectile.speed = speed
	new_projectile.damage = damage
	if lifetime > 0: # the default lifetime is 3 seconds.
		new_projectile.lifetime = lifetime
	new_projectile.target = attack_target.global_position
	new_projectile.valid_hitbox_types = target_types
	new_projectile.shooter = shooter

	return new_projectile

func _on_attack_timer_timeout():
	attack_timer.stop()

func target_is_in_range(target):
	attack_target = target
	var target_in_range = false
	for i in get_overlapping_bodies():
		if i == attack_target:
			target_in_range = true
			break
	for i in get_overlapping_areas():
		if i == attack_target:
			target_in_range = true
			break
	return target_in_range

func _set_layers(obj):
	if target_types["enemy"]:
		obj.set_collision_mask_value(4, true)
	if target_types["player"]:
		obj.set_collision_mask_value(1, true)
		obj.set_collision_layer_value(1, true)
	if target_types["car"]:
		obj.set_collision_mask_value(3, true)
	if target_types["cover"]:
		obj.set_collision_mask_value(5, true)
	if target_types["terrain"]:
		obj.set_collision_mask_value(9, true)
		pass
