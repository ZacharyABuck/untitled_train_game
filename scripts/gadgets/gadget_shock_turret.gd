extends Turret

func _ready():
	var buffs = {"shock": 1}
	WeaponInfo.attach_buffs(buffs, active_buffs)
	super()
