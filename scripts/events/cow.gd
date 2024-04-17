extends CharacterBody2D

var target
var move_speed: float = 200.0

signal move_completed

func _physics_process(delta):
	if target != null:
		look_at(target)
		velocity = global_position.direction_to(target) * move_speed * delta
	if global_position == target:
		move_completed.emit()
		queue_free()
	move_and_collide(velocity)
