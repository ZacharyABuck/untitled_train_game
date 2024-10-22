extends PanelContainer

@onready var left_upper = $VBoxContainer/HBoxContainer/LeftUpper
@onready var left_lower = $VBoxContainer/HBoxContainer/LeftLower
@onready var right_upper = $VBoxContainer/HBoxContainer2/RightUpper
@onready var right_lower = $VBoxContainer/HBoxContainer2/RightLower

@onready var car_sprite = $VBoxContainer/CarSprite
@onready var mouse_detector = $VBoxContainer/CarSprite/MouseDetector

var car_number: int
var slots: Dictionary
var equipped_merc_panel
signal clicked

func _ready():
	slots = {"LeftUpper": left_upper, "LeftLower": left_lower, "RightUpper": right_upper, "RightLower": right_lower}
	for slot in slots:
		slots[slot].get_child(0).pressed.connect(hard_point_pressed.bind(slots[slot]))

	check_for_gadgets()
	
	if car_number == 0:
		car_sprite.texture = TrainInfo.cars_roster["engine"]["sprite"]

#func _process(_delta):
	#if car_number != null and CurrentRun.world.current_train_info.cars_inventory.has(car_number):
		#for slot in slots:
			#if CurrentRun.world.current_train_info.cars_inventory[car_number]["gadgets"].has(slot) and\
			#CurrentRun.world.current_train_info.cars_inventory[car_number]["gadgets"][slot]["upkeep_paid"] == false:
				#slots[slot].get_child(2).play("flash")
			#else:
				#slots[slot].get_child(2).play("still")

func check_upkeep():
	if car_number != null and CurrentRun.world.current_train_info.cars_inventory.has(car_number):
		for slot in slots:
			if CurrentRun.world.current_train_info.cars_inventory[car_number]["gadgets"].has(slot) and\
			CurrentRun.world.current_train_info.cars_inventory[car_number]["gadgets"][slot]["upkeep_paid"] == false:
				slots[slot].get_child(2).play("flash")
			else:
				slots[slot].get_child(2).play("still")

func check_for_gadgets():
	if !CurrentRun.world.current_train_info.cars_inventory.is_empty():
		var cars_inventory = CurrentRun.world.current_train_info.cars_inventory
		for gadget in cars_inventory[car_number]["gadgets"].keys():
			for hard_point in cars_inventory[car_number]["hard_points"].keys():
				if hard_point == gadget:
					populate_slot(gadget, cars_inventory[car_number]["gadgets"][gadget]["gadget"])

func populate_slot(location, gadget):
	for slot in slots.keys():
		if slot == location:
			slots[slot].set_meta("gadget", gadget)
			slots[slot].get_child(1).texture = GadgetInfo.gadget_roster[gadget]["sprite"]

func hard_point_pressed(slot):
	if slot.has_meta("gadget"): 
		AudioSystem.play_audio("basic_button_click", -10)
		var gadget = slot.get_meta("gadget")
		clicked.emit(gadget, car_number, slot)


