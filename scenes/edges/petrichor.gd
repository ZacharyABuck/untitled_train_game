extends Edge

var heal_amount: float = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CurrentRun.world.current_level_info.active_level.weather == "rain":
		if CurrentRun.world.current_player_info.active_player.health_component.health < \
		CurrentRun.world.current_player_info.active_player.health_component.MAX_HEALTH:
			heal_player(heal_amount*delta)

func heal_player(amount):
	CurrentRun.world.current_player_info.current_health += amount
	CurrentRun.world.current_player_info.active_player.health_component.health += amount
	CurrentRun.world.current_player_info.active_player.health_component.healthbar.value = CurrentRun.world.current_player_info.active_player.health_component.health
	

func handle_level_up():
	heal_amount += 0.1
	print("Updated Heal Amount: " + str(heal_amount))

func update_player_info():
	pass
