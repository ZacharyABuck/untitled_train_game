extends Node2D
class_name Turret

var target
var hard_point

@onready var gun = $ProjectileAttackComponent

func _physics_process(_delta):
	if target != null:
		look_at(target.global_position)
		if gun.target_is_in_range(target):
			gun.shoot_if_target_in_range(target)
	if target == null or !gun.target_is_in_range(target):
		check_for_targets()

func _on_projectile_attack_component_area_entered(area):
	if target == null:
		if area.get_parent().is_in_group("enemy"):
			target = area.get_parent()

func check_for_targets():
	for i in gun.get_overlapping_areas():
		if i.get_parent().is_in_group("enemy"):
			target = i.get_parent()
