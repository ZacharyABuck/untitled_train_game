extends Enemy

func _ready():
	super()
	target = CurrentRun.world.current_train_info.furnace

func _physics_process(delta):
	if target == null:
		target = CurrentRun.world.current_train_info.furnace
	if state != "dead":
		look_at(target.global_position)
		if projectile_attack_component.target_is_in_range(target):
			state = "attacking"
			projectile_attack_component.shoot_if_target_in_range(target)
		else:
			state = "moving"
			velocity = global_position.direction_to(target.global_position)*(speed*delta)
			move_and_slide()
	else:
		queue_free()
