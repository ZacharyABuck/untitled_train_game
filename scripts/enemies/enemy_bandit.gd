extends Enemy

func _ready():
	find_stats("bandit")
	target = CurrentRun.world.current_player_info.active_player

func _physics_process(delta):
	if target == null:
		target = CurrentRun.world.current_player_info.active_player
	if state != "dead":
		look_at(target.global_position)
		if projectile_attack_component.target_is_in_range(target):
			state = "attacking"
			projectile_attack_component.shoot_if_target_in_range(target)
		else:
			state = "moving"
			move_and_collide(global_position.direction_to(target.global_position)*(speed*delta))
	else:
		queue_free()
