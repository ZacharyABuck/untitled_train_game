extends Edge

var charge_increase_amount: int = 2

func handle_level_up():
	CurrentRun.world.current_player_info.current_charge_recovery_rate += charge_increase_amount
