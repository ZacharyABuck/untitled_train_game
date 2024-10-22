extends Edge

var attack_delay_bonus: float = 0.1
var buffs = {"attack_delay": attack_delay_bonus}

func handle_level_up():
	attack_delay_bonus += 0.1
	buffs = {"attack_delay": attack_delay_bonus}

func area_entered(area):
	var receiver = area.get_parent()
	WeaponInfo.attach_buffs(buffs, receiver.active_buffs)

func area_exited(area):
	var receiver = area.get_parent()
	WeaponInfo.detach_buffs(buffs, receiver.active_buffs)
