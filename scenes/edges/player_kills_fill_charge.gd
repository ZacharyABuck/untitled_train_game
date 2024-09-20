extends Edge

var charge_amount: int = 5

func handle_level_up():
	charge_amount += 5

func fill_meter():
	player.charge_attack_bar.value += charge_amount
	print("Player Charge fill: " + str(player.charge_attack_bar.value))
