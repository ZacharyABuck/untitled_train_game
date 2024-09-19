extends Node2D
class_name ChargeAttack

@export var target_types = {
	"player":false,
	"enemy":false,
	"car":false,
	"cover":false,
	"terrain":false
}

@export var bullet: PackedScene
@export var bullet_speed: int
@export var damage: int
@export var shoot_sound: AudioStreamPlayer
@export var buff_receiver: Area2D
@export var lifetime: int


var player

var charge_targeting_component_reference = preload("res://scenes/charge_attacks/charge_targeting_component.tscn")
var charge_targeting_component
var final_score: int

var zoom_tween: Tween
var move_tween: Tween

func _ready():
	player = get_parent()
	
	var new_targeting_component = charge_targeting_component_reference.instantiate()
	add_child(new_targeting_component)
	charge_targeting_component = new_targeting_component

func initiate_charge():
	#zoom camera
	#var camera = player.camera
	#zoom_tween = create_tween()
	#move_tween = create_tween()
	#zoom_tween.tween_property(camera, "zoom", Vector2(1.1,1.1), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#move_tween.tween_property(camera, "global_position", get_global_mouse_position(), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#
	charge_targeting_component.shrink()
		
func release_charge():
	player.charging = false
	#var camera = player.camera
	#
	#zoom_tween.kill()
	#move_tween.kill()
	#zoom_tween = create_tween()
	#move_tween = create_tween()
	#zoom_tween.tween_property(camera, "zoom", Vector2(1,1), .5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#move_tween.tween_property(camera, "global_position", global_position, .5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#
	final_score = charge_targeting_component.finish()
	_shoot()

func _shoot():
	if shoot_sound != null:
		shoot_sound.play()
	
	var new_bullet = _instantiate_bullet()
	# Add the bullet to the parent scene of the shooter, which fires the projectile.
	CurrentRun.world.add_child(new_bullet)

func _instantiate_bullet():
	# Set core variables of Bullet. The Bullet needs to always have these variables.
	# speed, damage, global_position, valid_hitbox_types
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = player.global_position
	
	#check for buffs
	if buff_receiver != null:
		var car_buffs = owner.car.active_buffs
		for buff in car_buffs:
			if !buff_receiver.active_buffs.has(buff):
				buff_receiver.active_buffs.append(buff)
		new_bullet.active_buffs = buff_receiver.active_buffs
	
	new_bullet.speed = bullet_speed
	new_bullet.damage = clamp(damage - final_score*0.5, damage*0.5, damage)
	if lifetime > 0: # the default lifetime is 3 seconds.
		new_bullet.lifetime = lifetime
	new_bullet.target = get_global_mouse_position()
	new_bullet.valid_hitbox_types = target_types

	return new_bullet
