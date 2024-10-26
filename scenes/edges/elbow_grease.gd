extends Edge

var buffs = {"attack_delay": 1, "poison": 1, "fire": 1}

func _ready():
	super()
	
	for car in CurrentRun.world.current_train_info.cars_inventory:
		for hard_point in CurrentRun.world.current_train_info.cars_inventory[car]["hard_points"]:
			CurrentRun.world.current_train_info.cars_inventory[car]["hard_points"][hard_point].gadget_built.connect(add_buffs)


func add_buffs(gadget):
	WeaponInfo.attach_buffs(buffs, gadget.active_buffs)
	await get_tree().create_timer(5).timeout
	WeaponInfo.detach_buffs(buffs, gadget.active_buffs)

func handle_level_up():
	for buff in buffs:
		buffs[buff] += 0.5
