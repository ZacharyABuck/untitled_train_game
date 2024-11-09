extends HealthComponent

func _handle_death():
	CurrentRun.world.current_level_info.calculate_random_drop(character)
	ExperienceSystem.give_experience.emit(character.experience)
	CurrentRun.world.current_level_info.active_level.enemy_killed()
	character.state = "dead"
	animation.play("death")
	if character is RigidBody2D:
		character.set_collision_layer_value(4, false)
		character.set_collision_mask_value(4, false)
