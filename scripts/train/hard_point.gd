extends Node2D

@onready var sprite = $Sprite2D
@onready var radial_menu = $RadialMenu


var gadget
var location
var car

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass

func add_gadget(requested_gadget):
	if PlayerInfo.current_money >= requested_gadget["cost"]:
		GadgetInfo.selected_gadget = null
		LevelInfo.active_level.close_all_ui()
		$BuildSound.play()
		PlayerInfo.current_money -= requested_gadget["cost"]
		print("New Gadget: " + requested_gadget["name"])
		gadget = requested_gadget
		var new_gadget = requested_gadget["scene"].instantiate()
		new_gadget.hard_point = self
		car.gadgets.add_child(new_gadget)
		new_gadget.global_position = global_position
		radial_menu.queue_free()
	else:
		var label = LevelInfo.active_level.alert_label
		label.text = "Not Enough Money!"
		label.get_child(0).play("alert_flash_short")
		label.show()
