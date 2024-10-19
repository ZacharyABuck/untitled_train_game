extends Character

var merc_name
var merc_type
var ranks = {}
var buffs = {}

func _ready():
	super()
	merc_type = CurrentRun.world.current_character_info.mercs_inventory[merc_name]["type"]
	ranks = CurrentRun.world.current_character_info.mercs_inventory[merc_name]["ranks"]
	for rank in ranks.keys():
		for buff in ranks[rank]:
			if ranks[rank][buff]["value"] is int or ranks[rank][buff]["value"] is float:
				if buffs.has(buff):
					buffs[buff] += ranks[rank][buff]["value"]
				else:
					buffs[buff] = ranks[rank][buff]["value"]
			else:
				buffs[buff] = ranks[rank][buff]["value"]
	WeaponInfo.attach_buffs(buffs, car.active_buffs)
