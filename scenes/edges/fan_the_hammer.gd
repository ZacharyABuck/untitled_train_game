extends Edge
# 20% attack speed
var attack_speed_multiplier: float = 0.2

func _ready():
	CurrentRun.world.current_player_info.current_attack_delay_modifier = CurrentRun.world.current_player_info.base_attack_delay_modifier
	super()

func _calculate_attack_speed_multiplier():
	var final_multiplier = 1 - attack_speed_multiplier
	return final_multiplier

func handle_level_up():
	update_player_info()

func update_player_info():
	CurrentRun.world.current_player_info.current_attack_delay_modifier  *= _calculate_attack_speed_multiplier()
	print("Updated player attack delay modifier: ", CurrentRun.world.current_player_info.current_attack_delay_modifier)
	CurrentRun.world.current_player_info.active_player.refresh_current_ranged_weapon_stats()
