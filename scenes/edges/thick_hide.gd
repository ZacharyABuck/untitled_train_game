extends Edge

var armor_addition = 1

func handle_level_up():
	armor_addition += 1
	update_player_info()

func update_player_info():
	CurrentRun.world.current_player_info.current_armor = armor_addition
	CurrentRun.world.current_player_info.active_player.health_component.ARMOR_VALUE = CurrentRun.world.current_player_info.current_armor
	print("ARMOR: " + str(CurrentRun.world.current_player_info.active_player.health_component.ARMOR_VALUE))
