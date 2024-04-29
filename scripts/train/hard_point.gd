extends Node2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var mouse_indicator = $MouseIndicator
@onready var radial_menu = $RadialMenu


var gadget
var location
var car

# Called when the node enters the scene tree for the first time.
func _ready():
	radial_menu.hide()

func _process(delta):
	mouse_indicator.global_rotation = 0

#detect right click
func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if gadget == null and event.is_action_pressed("strike") and \
	TrainInfo.cars_inventory[PlayerInfo.active_player.active_car]["node"] == car:
		#hide gadget menu
		if radial_menu.visible == true:
			LevelInfo.active_level.close_all_ui()
		#show gadget menu
		else:
			$MenuOpenSound.play()
			animation_player.play("still")
			car.hide_radial_menus()
			Engine.set_time_scale(.2)
			radial_menu.show()
			radial_menu.open_menu()
			LevelInfo.active_level.ui_open = true

func add_gadget(requested_gadget):
	LevelInfo.active_level.close_all_ui()
	if PlayerInfo.current_money >= requested_gadget["cost"]:
		$BuildSound.play()
		PlayerInfo.current_money -= requested_gadget["cost"]
		print("New Gadget: " + requested_gadget["name"])
		gadget = requested_gadget
		var new_gadget = requested_gadget["scene"].instantiate()
		new_gadget.hard_point = self
		car.gadgets.add_child(new_gadget)
		new_gadget.global_position = global_position
	else:
		var label = LevelInfo.active_level.alert_label
		label.text = "Not Enough Money!"
		label.get_child(0).play("alert_flash_short")
		label.show()

#show animation when mouse is hovering
func _on_area_2d_mouse_entered():
	if LevelInfo.active_level.ui_open == false and gadget == null:
		animation_player.play("flash")
	else:
		animation_player.play("still")

func _on_area_2d_mouse_exited():
	animation_player.play("still")
