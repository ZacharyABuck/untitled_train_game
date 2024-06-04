extends Edge

var armor_addition = 1

func handle_level_up():
	armor_addition += 1
	update_player_info()

func update_player_info():
	PlayerInfo.current_armor = armor_addition
	PlayerInfo.active_player.health_component.ARMOR_VALUE = PlayerInfo.current_armor
	print("ARMOR: " + str(PlayerInfo.active_player.health_component.ARMOR_VALUE))
