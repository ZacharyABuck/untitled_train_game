extends Node2D
class_name Turret

var target
var hard_point
var car

@export var BUFF_RECEIVER: Area2D

var raycast: RayCast2D
var cooldown: Timer

@onready var gun = $ProjectileAttackComponent
@export var moving_target_component: Area2D

func _ready():
	#create cooldown timer
	cooldown = Timer.new()
	add_child(cooldown)
	cooldown.wait_time = gun.attack_timer.wait_time
	cooldown.one_shot = true

	hard_point = get_parent()
	car = hard_point.get_parent().owner
	initialize_raycast()
	
	if BUFF_RECEIVER and car.active_buffs.has("shock"):
		BUFF_RECEIVER.toggle_shock_fx(true)

func _physics_process(_delta):
	if target == null:
		check_for_targets()
		gun.attack_timer.stop()
	else:
		set_moving_target()
		look_at(target.global_position)
		if cooldown.is_stopped():
			if gun.target_is_in_range(target):
				shoot_if_raycast_ok()
			else:
				check_for_targets()

func set_moving_target():
	moving_target_component.move_target(target, global_position, target.linear_velocity, gun.BULLET_SPEED)

func shoot_if_raycast_ok():
	cooldown.start()
	await get_tree().create_timer(.05).timeout
	if target != null:
		var raycast_ok = update_raycast(target.global_position)
		if raycast_ok:
			gun.shoot_if_target_in_range(moving_target_component)
		else:
			check_for_targets()
	else:
		check_for_targets()

func initialize_raycast():
	raycast = RayCast2D.new()
	add_child(raycast)
	raycast.position = position
	raycast.enabled = true
	raycast.set_collision_mask_value(1, false)
	raycast.set_collision_mask_value(3, true)

func update_raycast(pos) -> bool:
	raycast.set_target_position(raycast.to_local(pos))
	raycast.force_raycast_update()
	raycast.force_update_transform()

	if raycast.is_colliding():
		return false
	else:
		return true

func check_for_targets():
	for i in gun.get_overlapping_areas():
		if i.get_parent().is_in_group("enemy"):
			var raycast_ok = update_raycast(i.get_parent().global_position)
			if raycast_ok:
				target = i.get_parent()
				break
