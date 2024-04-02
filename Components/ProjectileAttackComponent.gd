extends Area2D
class_name ProjectileAttackComponent

@export var TARGET_TYPES = {
	"player":false,
	"enemy":false,
	"car":false,
	"terrain":false
}
@export var ATTACK_TIMER := Timer
@export var BULLET_SPEED := 30
@export var DAMAGE_PER_BULLET := 2
@export var NUMBER_OF_BULLETS := 1
@export var PROJECTILE : PackedScene # <--Must extend 'Projectile'
@export var MOBILE_ATTACK := false
@export var TARGET_AREA : CollisionShape2D

var attack_timer
var speed
var projectile
var damage
var number_of_bullets
var shooter
var type
var target_types
var mobile_attack
var attack_target

func _ready():
	attack_timer = ATTACK_TIMER
	speed = BULLET_SPEED
	projectile = PROJECTILE
	damage = DAMAGE_PER_BULLET
	number_of_bullets = NUMBER_OF_BULLETS
	shooter = get_parent()
	target_types = TARGET_TYPES
	mobile_attack = MOBILE_ATTACK
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	_set_layers(self)

func _process(delta):
	pass

func shoot_if_target_in_range(target):
	attack_target = target
	if attack_timer.is_stopped():
		for i in get_overlapping_bodies():
			if i == attack_target:
				_shoot()
				break

func shoot_at_target(target):
	attack_target = target
	# fire initially, then kick off timer.
	if attack_timer.is_stopped():
		_shoot()

func _shoot():
	var new_projectile = _instantiate_bullet()
	# Add the bullet to the parent scene of the shooter, which fires the projectile.
	shooter.get_parent().add_child(new_projectile)
	attack_timer.start()

func _instantiate_bullet():
	# Set core variables of Bullet. The Bullet needs to always have these variables.
	# speed, damage, global_position, valid_hitbox_types
	var new_projectile = projectile.instantiate()
	new_projectile.global_position = shooter.global_position
	new_projectile.speed = speed
	new_projectile.damage = damage
	new_projectile.target = attack_target.global_position
	new_projectile.valid_hitbox_types = target_types

	return new_projectile

func _on_attack_timer_timeout():
	attack_timer.stop()
	shoot_if_target_in_range(attack_target)

func target_is_in_range(target):
	attack_target = target
	var target_in_range = false
	for i in get_overlapping_bodies():
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
	if target_types["terrain"]:
		# Add in collission mask for terrain if needed.
		pass
