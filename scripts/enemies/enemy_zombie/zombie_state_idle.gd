extends Node2D

func _physics_process(_delta):
	owner.animations.play("idle")
