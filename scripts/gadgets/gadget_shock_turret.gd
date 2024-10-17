extends Turret

func _ready():
	BUFF_RECEIVER.active_buffs["shock"] = true
	super()
