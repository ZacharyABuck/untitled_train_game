extends Node2D

func _physics_process(_delta):
	owner.sprite.play("default")

func _on_move_timer_timeout():
	var rng = randi_range(1,10)
	if rng > 4:
		var random_pos = find_random_position()
		owner.target = random_pos
		owner.state = "running"
		owner.idle_timer.wait_time = randi_range(1,3)
		owner.move_timer.wait_time = randi_range(3,5)
		owner.idle_timer.start()

func find_random_position():
	var rng = Vector2(randi_range(-25,25), randi_range(-25,25))
	return rng
