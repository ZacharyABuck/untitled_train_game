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
	if PlayerInfo.current_money >= requested_gadget["cost"]:
		GadgetInfo.selected_gadget = null
		LevelInfo.active_level.close_all_ui()
		$BuildSound.play()
		PlayerInfo.current_money -= requested_gadget["cost"]
		print("New Gadget: " + requested_gadget["name"])
		
		if gadget != null:
			gadget.queue_free()
		var new_gadget = requested_gadget["scene"].instantiate()
		new_gadget.hard_point = self
		add_child(new_gadget)
		gadget = new_gadget
		new_gadget.global_position = global_position
		radial_menu.close_menu()
		radial_menu.update_menu(GadgetInfo.gadget_roster.find_key(requested_gadget))
	else:
		var label = LevelInfo.active_level.alert_label
		label.text = "Not Enough Money!"
		label.get_child(0).play("alert_flash_short")
		label.show()
