extends Node2D

func _physics_process(_delta):
	if owner.target != null:
		owner.attack_component.attack_if_target_in_range(owner.target)

func animation_finished():
	if owner.animations.animation == "recovery":
		if !owner.attack_component.target_is_in_range(owner.target):
			owner.state = "moving"
