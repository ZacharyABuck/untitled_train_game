# Template of a Projectile to grant base variables to all Projectiles.
# Contains commonly used functions and processors.
# Animations for a projectile should have at least the folliwing animations:
# --1. "travel", for one the projectile is in motion.
# --2. "hit", for when the projectile strikes a Hitbox.

extends RigidBody2D
class_name Projectile

@export var HITBOX : Area2D
@export var ANIMATIONS : AnimatedSprite2D
@export var SFX : AudioStreamPlayer2D

var target
var continuous_target
var speed = 600
var damage = 2
var pierces = false
var hitbox
var animations
var valid_hitbox_types
var lifetime = 3

var active_buffs: Array = []

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	hitbox = HITBOX
	animations = ANIMATIONS
	_connect_signals()
	_set_collisions()
	look_at(target)
	animations.play("travel")
	continuous_target = global_position.direction_to(target)

func _physics_process(delta):
	if animations.animation == "travel":
		move_and_collide(continuous_target * speed * delta)

func _on_area_2d_area_entered(area):
	if area is HurtboxComponent:
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
		linear_velocity = Vector2.ZERO
		animations.play("hit")
		var new_hitbox : HurtboxComponent = area
		var attack = Attack.new()
		attack.active_buffs = active_buffs
		attack.attack_damage = damage
		new_hitbox.damage(attack)
		if SFX:
			SFX.play()

func _on_animated_sprite_2d_animation_finished():
	if SFX:
		await SFX.finished
		queue_free()
	if animations.animation == "hit":
		queue_free()

func _connect_signals():
	hitbox.area_entered.connect(_on_area_2d_area_entered)
	animations.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	var lifetimer = get_tree().create_timer(lifetime)
	lifetimer.timeout.connect(_on_lifetimer_timeout)

func _set_collisions():
	if valid_hitbox_types["enemy"]:
		hitbox.set_collision_mask_value(4, true)
	if valid_hitbox_types["player"]:
		hitbox.set_collision_mask_value(1, true)
	if valid_hitbox_types["car"]:
		hitbox.set_collision_mask_value(3, true)
	if valid_hitbox_types["cover"]:
		hitbox.set_collision_mask_value(5, true)
	if valid_hitbox_types["terrain"]:
		# Add in collission mask for terrain if needed.
		pass

func _on_lifetimer_timeout():
	queue_free()

# not currently used by projectiles. We use physics process instead.
func _process(_delta):
	pass 

