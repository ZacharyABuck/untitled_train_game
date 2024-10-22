extends Turret

func _ready():
	gun.gun_shot.connect(poison_bullets)
	super()

func poison_bullets():
	active_buffs["poison"] = 1
