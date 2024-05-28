extends Node2D

func _physics_process(_delta):
	owner.attack_timer.stop()
	owner.hurtbox.disabled = true
	owner.animations.play("death")

func animation_finished():
	if owner.animations.animation == "death":
		owner.queue_free()
