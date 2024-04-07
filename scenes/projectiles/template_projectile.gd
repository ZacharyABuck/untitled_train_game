# Template of a Projectile to grant base variables to all Projectiles.
# Contains commonly used functions and processors.
# Animations for a projectile should have at least the folliwing animations:
# --1. "travel", for one the projectile is in motion.
# --2. "hit", for when the projectile strikes a Hitbox.

extends RigidBody2D
class_name Projectile

@export var HITBOX : Area2D
@export var ANIMATIONS : AnimatedSprite2D

var target
var speed = 30
var damage = 2
var pierces = false
var hitbox
var animations
var valid_hitbox_types

func _ready():
	hitbox = HITBOX
	animations = ANIMATIONS
	_connect_signals()
	_set_collisions()
	look_at(target)
	animations.play("travel")
	linear_velocity = global_position.direction_to(target) * speed

func _physics_process(_delta):
	move_and_collide(linear_velocity)

func _on_area_2d_area_entered(area):
	if area is HurtboxComponent:
		linear_velocity = Vector2.ZERO
		animations.play("hit")
		var hitbox : HurtboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = damage
		hitbox.damage(attack)

func _on_animated_sprite_2d_animation_finished():
	if animations.animation == "hit":
		queue_free()

func _connect_signals():
	hitbox.area_entered.connect(_on_area_2d_area_entered)
	animations.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _set_collisions():
	if valid_hitbox_types["enemy"]:
		hitbox.set_collision_mask_value(4, true)
	if valid_hitbox_types["player"]:
		hitbox.set_collision_mask_value(1, true)
	if valid_hitbox_types["car"]:
		hitbox.set_collision_mask_value(3, true)
	if valid_hitbox_types["terrain"]:
		# Add in collission mask for terrain if needed.
		pass

# not currently used by projectiles. We use physics process instead.
func _process(_delta):
	pass 

