extends Node2D

var target

var gadget_stats = GadgetInfo.gadget_roster["pistol_turret"]
var damage = gadget_stats["damage"]
var attack_cooldown = gadget_stats["attack_cooldown"]
@onready var gun = $ProjectileAttackComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if target != null:
		look_at(target.global_position)
		if gun.target_is_in_range(target):
			gun.shoot_if_target_in_range(target)

func _on_enemy_detector_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		target = area.get_parent()
