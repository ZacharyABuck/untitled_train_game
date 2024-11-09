extends Hazard

var zombie_bait_bullet = preload("res://scenes/projectiles/zombie_bait_bullet.tscn")

func _on_car_detector_body_entered(body):
	if body.get_parent().is_in_group("car"):
		var car = body.get_parent()
		var new_bullet = zombie_bait_bullet.instantiate()
		car.call_deferred("add_child", new_bullet)
		new_bullet.position = car.character_spawn_point.position

		queue_free()
