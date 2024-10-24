extends Turret

func _ready():
	#gun.gun_shot.connect(poison_bullets)
	super()
	var buffs = {"poison": 1}
	WeaponInfo.attach_buffs(buffs, active_buffs)

#func poison_bullets():
	#active_buffs["poison"] = 1
