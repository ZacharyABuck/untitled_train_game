extends ExplodingProjectile

func _ready():
	super()
	active_buffs["poison"] = true
