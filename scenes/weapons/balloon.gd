extends RigidBody2D

signal landed

var speed: float = 300
var target: Vector2

func _physics_process(delta):
	
	global_rotation_degrees = 0
	
	target = get_parent().character_spawn_point.global_position
	
	if target != null:
		move_and_collide(global_position.direction_to(target)*(speed*delta))
		
		if global_position.distance_to(target) <= 25:
			landed.emit(get_parent())
			queue_free()
