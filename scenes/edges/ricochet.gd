extends Edge

var buffs = {"ricochet": 1}

func _ready():
	super()
	
	WeaponInfo.attach_buffs(buffs, player.active_buffs)
	print("Updated ricochet amount: ", str(player.active_buffs["ricochet"]))

func handle_level_up():
	WeaponInfo.attach_buffs(buffs, player.active_buffs)
	print("Updated ricochet amount: ", str(player.active_buffs["ricochet"]))

func update_player_info():
	pass
