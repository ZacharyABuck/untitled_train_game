extends Passenger

var merc_name
var merc_type
var ranks = {}

func _ready():
	super()
	
	merc_type = CurrentRun.world.current_character_info.mercs_inventory[merc_name]["type"]
	ranks = CurrentRun.world.current_character_info.mercs_inventory[merc_name]["ranks"]
	
	var car_dict = CurrentRun.world.current_train_info.cars_inventory[car.index]
	
	for gadget in car_dict["gadgets"]:
		add_buffs_to_gadget(car_dict["gadgets"][gadget]["gadget"])
	
	for hard_point in car_dict["hard_points"]:
		hard_point.gadget_built.connect(add_buffs_to_gadget)

func add_buffs_to_gadget(gadget):
	for rank in ranks.keys():
		for buff in ranks[rank]:
			if GadgetInfo.buffs.keys().has(buff):
				var new_buff = GadgetInfo.buffs[buff].instantiate()
				new_buff.timed = false
				if new_buff.stats.has(buff):
					new_buff.stats[buff] = ranks[rank][buff]["value"]
				
				gadget.gun.add_child(new_buff)
