extends PanelContainer

@onready var left_upper = $VBoxContainer/HBoxContainer/LeftUpper
@onready var left_lower = $VBoxContainer/HBoxContainer/LeftLower
@onready var right_upper = $VBoxContainer/HBoxContainer2/RightUpper
@onready var right_lower = $VBoxContainer/HBoxContainer2/RightLower

@onready var car_sprite = $VBoxContainer/CarSprite
@onready var gadget_name_label = $VBoxContainer/CarSprite/VBoxContainer/GadgetNameLabel


var car_number: int
var slots: Dictionary

func _ready():
	slots = {"LeftUpper": left_upper, "LeftLower": left_lower, "RightUpper": right_upper, "RightLower": right_lower}
	for slot in slots:
		slots[slot].get_child(0).pressed.connect(hard_point_pressed.bind(slots[slot]))
		slots[slot].get_child(0).mouse_entered.connect(hard_point_hovered.bind(slots[slot]))
		slots[slot].get_child(0).mouse_exited.connect(hide_slot_info)
	
	check_for_gadgets()
	
	if car_number == 0:
		car_sprite.texture = TrainInfo.cars_roster["engine"]["sprite"]

func check_for_gadgets():
	var cars_inventory = CurrentRun.world.current_train_info.cars_inventory
	for gadget in cars_inventory[car_number]["gadgets"].keys():
		for hard_point in cars_inventory[car_number]["hard_points"].keys():
			if hard_point == gadget:
				populate_slot(gadget, cars_inventory[car_number]["gadgets"][gadget])

func populate_slot(location, gadget):
	for slot in slots.keys():
		if slot == location:
			slots[slot].set_meta("gadget", gadget)
			slots[slot].get_child(1).texture = GadgetInfo.gadget_roster[gadget]["sprite"]

func hard_point_hovered(slot):
	if slot.has_meta("gadget"):
		var gadget = slot.get_meta("gadget")
		gadget_name_label.text = "[center]" + GadgetInfo.gadget_roster[gadget]["name"] + "[/center]"
		gadget_name_label.show()

func hide_slot_info():
	gadget_name_label.hide()

func hard_point_pressed(slot):
	pass
