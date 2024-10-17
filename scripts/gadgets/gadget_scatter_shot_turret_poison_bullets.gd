extends Turret

func _ready():
	gun.gun_shot.connect(poison_bullets)
	super()

func poison_bullets():
	BUFF_RECEIVER.active_buffs["poison"] = true
