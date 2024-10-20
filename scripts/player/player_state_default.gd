extends Node2D

func _physics_process(_delta):
	owner.global_rotation_degrees = 0
	owner.sprite.look_at(get_global_mouse_position())
	get_input()
	animate_movement()
	owner.move_and_slide()

func get_input():
	# -- DIRECTIONAL INPUT -- #
	var input_direction = Input.get_vector("left", "right", "up", "down")
	owner.velocity = input_direction * CurrentRun.world.current_player_info.current_movespeed
	
func animate_movement():
	if Input.is_action_pressed("shoot"):
		owner.sprite.play("shooting")
		owner.running_sfx.stop()
	elif owner.velocity.is_equal_approx(Vector2.ZERO):
		owner.sprite.play("standing")
		owner.running_sfx.stop()
	else:
		owner.sprite.play("running")
		if !owner.running_sfx.playing:
			owner.running_sfx.play()

func _unhandled_input(event):
	if event.is_action_pressed("strike"):
		if owner.lasso != null and owner.lasso.active_projectile == null:
			CurrentRun.world.current_player_info.state = "lassoing"
			owner.lasso.windup()
	if event.is_action_pressed("shoot"):
		owner._shoot()

