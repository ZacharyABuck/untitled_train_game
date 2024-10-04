extends Node2D

func _physics_process(_delta):
	owner.animations.play("boarding")

func animation_finished():
	if owner.animations.animation == "boarding":
		CurrentRun.world.current_train_info.cars_inventory[owner.active_car]["node"].take_damage(owner.damage)
		if CurrentRun.world.current_train_info.cars_inventory[owner.active_car]["node"].health >= CurrentRun.world.current_train_info.cars_inventory[owner.active_car]["node"].max_health*.01:
			owner.animations.play("boarding")
		else:
			owner.state = "finish_boarding"
