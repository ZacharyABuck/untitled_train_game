extends Edge

var attack_delay_bonus: float = 0.1
var buffs = {"attack_delay": attack_delay_bonus}

func _ready():
	WeaponInfo.attach_buffs(buffs, CurrentRun.world.current_player_info.active_player.buff.active_buffs)
	super()

func handle_level_up():
	attack_delay_bonus += 0.1
