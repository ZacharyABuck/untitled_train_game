extends RigidBody2D

var target
var move_speed: float = 200.0
var damage = 5

func _physics_process(delta):
	if target != null:
		look_at(target)
		var velocity = global_position.direction_to(target) * move_speed * delta
		move_and_collide(velocity)

func _on_enemy_detector_area_entered(area):
	if area is HurtboxComponent:
		print("enemy hit by cow")
