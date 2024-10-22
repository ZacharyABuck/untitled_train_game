extends Edge

var buffs = {"ricochet": 1}

func _ready():
	WeaponInfo.attach_buffs(buffs, player.active_buffs)
	print("Updated ricochet amount: ", str(player.active_buffs["ricochet"]))
	super()

func handle_level_up():
	WeaponInfo.attach_buffs(buffs, player.active_buffs)
	print("Updated ricochet amount: ", str(player.active_buffs["ricochet"]))
