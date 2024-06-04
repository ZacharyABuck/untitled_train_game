extends Area2D

func move_target(target, pos, target_velocity, bullet_speed):
	var time = pos.distance_to(target.global_position)/bullet_speed
	var vector = target.global_transform.x*target_velocity
	global_position = (vector*time) + target.global_position
	return self
