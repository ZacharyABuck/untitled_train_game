extends Node2D

@onready var sprite = $Sprite2D
@onready var radial_menu = $RadialMenu


var gadget
var location
var car

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	pass

func add_gadget(requested_gadget):
	var label = LevelInfo.active_level.alert_label
	# CHECK IF PLAYER HAS ENOUGH MONEY
	if PlayerInfo.current_money < requested_gadget["cost"]:
		label.text = "Not Enough Money!"
		label.get_child(0).play("alert_flash_short")
		label.show()
	# CHECK IF CAR ALREADY HAS SURROUNDING GADGET
	elif requested_gadget["location"] == "car" and has_car_gadget():
		label.text = "Space Occupied!"
		label.get_child(0).play("alert_flash_short")
		label.show()
	# BUILD GADGET
	else:
		GadgetInfo.selected_gadget = null
		LevelInfo.active_level.close_all_ui()
		$BuildSound.play()
		PlayerInfo.current_money -= requested_gadget["cost"]
		print("New Gadget: " + requested_gadget["name"])
		if gadget != null:
			get_child(0).queue_free()
		var new_gadget = requested_gadget["scene"].instantiate()
		add_child(new_gadget)
		gadget = requested_gadget
		match requested_gadget["location"]:
			"hard_point":
				new_gadget.global_position = global_position
			"car":
				new_gadget.global_position = car.global_position
				new_gadget.icon_sprite.global_position = global_position
		radial_menu.close_menu()
		radial_menu.update_menu(GadgetInfo.gadget_roster.find_key(requested_gadget))
		PlayerInfo.state = "default"

func has_car_gadget() -> bool:
	for i in car.hard_points.get_children():
		if i.get_child(0).gadget != null:
			if i.get_child(0).gadget["location"] == "car":
				return true
	return false
