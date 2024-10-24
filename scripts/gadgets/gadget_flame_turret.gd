extends Turret

func _ready():
	super()
	var buffs = {"fire": 2}
	WeaponInfo.attach_buffs(buffs, active_buffs)
