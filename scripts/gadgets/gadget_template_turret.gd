extends Node2D
class_name Turret

var target
var hard_point
var car

var raycast: RayCast2D
var cooldown: Timer

@onready var gun = $ProjectileAttackComponent

func _ready():
	cooldown = Timer.new()
	add_child(cooldown)
	cooldown.wait_time = gun.attack_timer.wait_time
	cooldown.one_shot = true

	hard_point = get_parent()
	car = hard_point.get_parent().owner
	initialize_raycast()
	var point = car
	for i in car.boarding_points.get_children():
		if position.distance_to(i.position) < position.distance_to(point.position):
			point = i
	look_at(point.global_position - global_position)

func _physics_process(_delta):
	if target == null:
		check_for_targets()
		gun.attack_timer.stop()
	else:
		if gun.target_is_in_range(target) and !raycast.is_colliding():
			look_at(target.global_position)
			if cooldown.is_stopped():
				gun.shoot_if_target_in_range(target)
				cooldown.start()
		else: 
			check_for_targets()
			gun.attack_timer.stop()

func initialize_raycast():
	raycast = RayCast2D.new()
	add_child(raycast)
	raycast.position = position
	raycast.enabled = true
	raycast.set_collision_mask_value(1, false)
	raycast.set_collision_mask_value(3, true)

func check_for_targets():
	for i in gun.get_overlapping_areas():
		if i.get_parent().is_in_group("enemy"):
			raycast.set_target_position(raycast.to_local(i.global_position))
			raycast.force_update_transform()
			raycast.force_raycast_update()
			if !raycast.is_colliding():
				target = i.get_parent()
				break
