extends Edge

var buffs = {"poison": 1}

func handle_level_up():
	$BuffArea/CollisionShape2D.shape.radius *= 1.2
	$Aura.scale *= 1.2

func area_entered(area):
	var receiver = area.get_parent()
	WeaponInfo.attach_buffs(buffs, receiver.active_buffs)

func area_exited(area):
	var receiver = area.get_parent()
	WeaponInfo.detach_buffs(buffs, receiver.active_buffs)
