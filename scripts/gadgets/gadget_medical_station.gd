extends Gadget

@export var heal_range: int
@export var heal_amount: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CurrentRun.world.current_player_info.active_player != null and CurrentRun.world.current_player_info.active_player.active_car != null:
		var active_car = CurrentRun.world.current_player_info.active_player.active_car
		if (active_car >= car.index - heal_range and active_car <= car.index + heal_range) and \
		CurrentRun.world.current_player_info.active_player.health_component.health < CurrentRun.world.current_player_info.active_player.health_component.MAX_HEALTH:
			heal_player(heal_amount*delta)
		else:
			$AnimationPlayer.stop()
			$Ring.hide()

func heal_player(amount):
	CurrentRun.world.current_player_info.current_health += amount
	CurrentRun.world.current_player_info.active_player.health_component.health += amount
	CurrentRun.world.current_player_info.active_player.health_component.healthbar.value = CurrentRun.world.current_player_info.active_player.health_component.health
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("flash_ring")
		$Ring.show()
