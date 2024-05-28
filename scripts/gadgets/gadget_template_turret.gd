extends Node2D
class_name Turret

var target
var hard_point
var car

var raycast: RayCast2D

@onready var gun = $ProjectileAttackComponent

func _ready():
	hard_point = get_parent()
	car = hard_point.get_parent().owner
	initialize_raycast()
	
	var point = car
	for i in car.boarding_points.get_children():
		if position.distance_to(i.position) < position.distance_to(point.position):
			point = i
	look_at(point.global_position - global_position)


func _physics_process(_delta):
	if target != null:
		raycast.set_target_position(raycast.to_local(target.global_position))
		if !raycast.is_colliding():
			look_at(target.global_position)
			gun.shoot_if_target_in_range(target)
	if target == null or !gun.target_is_in_range(target):
		check_for_targets()

func initialize_raycast():
	raycast = RayCast2D.new()
	add_child(raycast)
	raycast.position = position
	raycast.enabled = true
	raycast.set_collision_mask_value(1, false)
	raycast.set_collision_mask_value(3, true)

func _on_projectile_attack_component_area_entered(area):
	if target == null:
		if area.get_parent().is_in_group("enemy"):
			target = area.get_parent()

func check_for_targets():
	gun.attack_timer.stop()
	for i in gun.get_overlapping_areas():
		raycast.set_target_position(raycast.to_local(i.global_position))
		if !raycast.is_colliding() and i.get_parent().is_in_group("enemy"):
			target = i.get_parent()
