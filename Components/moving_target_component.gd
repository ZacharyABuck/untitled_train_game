extends Area2D

@onready var aim_assist_visual = $AimAssistVisual

func _ready():
	if get_parent() is Enemy:
		aim_assist_visual.process_mode = Node.PROCESS_MODE_INHERIT
		aim_assist_visual.show()

func move_target(target, pos, target_velocity, bullet_speed):
	if bullet_speed == 0:
		global_position = target.global_position
	else:
		var a = bullet_speed*bullet_speed - target_velocity.dot(target_velocity)
		var b = 2*target_velocity.dot(target.global_position - pos)
		var c = (target.global_position-pos).dot(target.global_position-pos)
		
		var time = 0.0
		if bullet_speed > target_velocity.length():
			time = (b+sqrt(b*b+4*a*c)) / (2*a)
		global_position = target.global_position+time*target_velocity
		
	return self
