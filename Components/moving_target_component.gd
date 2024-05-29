extends RigidBody2D

func move_target(target_pos, pos, target_velocity, bullet_speed):
	get_child(0).disabled = true
	var a:float = bullet_speed*bullet_speed - target_velocity.dot(target_velocity)
	var b:float = 2*target_velocity.dot(target_pos-pos)
	var c:float = (target_pos-pos).dot(target_pos-pos)
	var time:float = 0.0
	if bullet_speed > target_velocity.length():
		time = (b+sqrt(b*b+4*a*c)) / (2*a)
	global_position = target_pos+time*target_velocity
	get_child(0).disabled = false
