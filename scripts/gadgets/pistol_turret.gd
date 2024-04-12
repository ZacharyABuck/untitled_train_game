extends Node2D

var target
var hard_point

var gadget_stats = GadgetInfo.gadget_roster["pistol_turret"]
var damage = gadget_stats["damage"]
var attack_cooldown = gadget_stats["attack_cooldown"]
@onready var gun = $ProjectileAttackComponent

func _physics_process(delta):
	if target != null:
		look_at(target.global_position)
		if gun.target_is_in_range(target):
			gun.shoot_if_target_in_range(target)

func _on_enemy_detector_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		target = area.get_parent()
