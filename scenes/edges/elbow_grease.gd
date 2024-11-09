extends Edge

var buffs = [GadgetInfo.buffs["fire"], GadgetInfo.buffs["poison"], GadgetInfo.buffs["attack_delay"]]

var lifetime = 5.0

func _ready():
	super()
	
	for car in CurrentRun.world.current_train_info.cars_inventory:
		for hard_point in CurrentRun.world.current_train_info.cars_inventory[car]["hard_points"]:
			CurrentRun.world.current_train_info.cars_inventory[car]["hard_points"][hard_point].gadget_built.connect(add_buffs)

func add_buffs(gadget):
	for buff in buffs:
		var new_buff = buff["scene"].instantiate()
		new_buff.lifetime = lifetime
		gadget.gun.add_child(new_buff)

func handle_level_up():
	lifetime += 2.0
