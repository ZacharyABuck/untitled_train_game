extends Node2D

func _physics_process(_delta):
	owner.animations.play("boarding")

func animation_finished():
	if owner.animations.animation == "boarding":
		TrainInfo.cars_inventory[owner.active_car]["node"].take_damage(owner.damage)
		if TrainInfo.cars_inventory[owner.active_car]["node"].health <= 0:
			owner.state = "finish_boarding"
		else:
			owner.animations.play("boarding")
