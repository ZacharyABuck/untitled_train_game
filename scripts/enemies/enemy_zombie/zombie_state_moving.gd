extends Node2D

func _physics_process(delta):
	owner.set_collision_mask_value(3, true)
	owner.animations.play("moving")
	if owner.target != null:
		owner.velocity = owner.global_position.direction_to(owner.target.global_position)*(owner.speed*delta)
		owner.move_and_slide()
		owner.look_at(owner.target.global_position)
		if owner.attack_component.target_is_in_range(owner.target) and owner.boarded:
			owner.state = "attacking"
	
