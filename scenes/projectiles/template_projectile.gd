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

var shooter
var target
var continuous_target
var speed = 600
var damage = 2
var pierces = false
var hitbox
var animations
var valid_hitbox_types
var lifetime = 3

var active_buffs: Dictionary

signal hit_target
var last_enemy_hit: Area2D

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	hitbox = HITBOX
	animations = ANIMATIONS
	animations.play("travel")
	_connect_signals()
	_set_collisions()
	look_at(target)
	continuous_target = global_position.direction_to(target)

func _physics_process(delta):
	if animations.animation == "travel":
		move_and_collide(continuous_target * speed * delta)

func _on_area_2d_area_entered(area):
	if area is HurtboxComponent and area != last_enemy_hit:
		hit_target.emit(area)
	
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
		linear_velocity = Vector2.ZERO
		animations.play("hit")
		var new_hitbox : HurtboxComponent = area
		var attack = Attack.new()
		
		WeaponInfo.attach_buffs(active_buffs, attack.active_buffs)

		if active_buffs.has("damage"):
			attack.attack_damage = damage * active_buffs["damage"]
		else:
			attack.attack_damage = damage
		
		new_hitbox.damage(attack, shooter)
		if SFX:
			SFX.play()
			
		if shooter != null and shooter.active_buffs.has("ricochet"):
			for bullet in shooter.active_buffs["ricochet"]:
				var scene = PackedScene.new()
				scene.pack(self)
				var new_ricochet = _build_ricochet(scene.instantiate(), area)
				print(new_ricochet)
				CurrentRun.world.current_level_info.active_level.bullets.call_deferred("add_child", new_ricochet)

func _build_ricochet(b, area):
	b.global_position = area.global_position
	b.last_enemy_hit = area
	b.speed = speed
	b.damage = damage
	b.target = Vector2(area.global_position.x + randi_range(-100,100), area.global_position.y + randi_range(-100,100))
	b.valid_hitbox_types = {"enemy":true, "player":false, "car":false, "cover":false, "terrain":true}
	b.lifetime = .5
	
	return b

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
		hitbox.set_collision_mask_value(9, true)
		pass

func _on_lifetimer_timeout():
	queue_free()
