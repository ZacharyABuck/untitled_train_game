extends Node2D

func _physics_process(_delta):
	owner.sprite.play("running")
 	
	if owner.target != null:
		owner.look_at(owner.target + owner.global_position)
		owner.move_and_collide(owner.global_position.direction_to(owner.target + owner.global_position))
		

func _on_idle_timer_timeout():
	owner.state = "idle"
