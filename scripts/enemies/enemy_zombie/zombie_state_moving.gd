extends Node2D

func _physics_process(delta):
	#check shock
	if owner.shocked:
		owner.speed = owner.enemy_stats["speed"] * .3
	else:
		owner.speed = owner.enemy_stats["speed"]
		if owner.elite:
			owner.speed += EnemyInfo.elite_modifiers["speed"]
	

	owner.set_collision_mask_value(3, true)
	owner.animations.play("moving")
	if owner.target != null:
		owner.move_and_collide(owner.global_position.direction_to(owner.target.global_position)*(owner.speed*delta))
		owner.look_at(owner.target.global_position)
		if owner.attack_component.target_is_in_range(owner.target) and owner.boarded:
			owner.state = "attacking"
	
