extends Edge

var attack_delay_bonus: float = 0.1

func _ready():
	if !CurrentRun.world.current_player_info.active_player.buff.active_buffs.has("attack_delay"):
		CurrentRun.world.current_player_info.active_player.buff.active_buffs.append("attack_delay")
		CurrentRun.world.current_player_info.active_player.buff.attack_delay_bonus = attack_delay_bonus
	super()

func handle_level_up():
	attack_delay_bonus += 0.1
