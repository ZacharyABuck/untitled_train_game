extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	owner.animations.play("finish_boarding")
	if owner.boarded == false:
		owner.boarded = true
		finish_boarding()

func finish_boarding():
	var car = TrainInfo.cars_inventory[owner.active_car]["node"]
	car.boarding_sfx.play()
	var point = car.boarding_points.get_child(0)
	for i in car.boarding_points.get_children():
		if owner.position.distance_to(i.position) < owner.position.distance_to(point.position):
			point = i
	owner.look_at(point.global_position)
	var tween = get_tree().create_tween()
	tween.tween_property(owner, "position", point.position, .6)

func animation_finished():
	if owner.animations.animation == "finish_boarding":
		owner.state = "moving"