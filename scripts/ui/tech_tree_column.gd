extends VBoxContainer

var trainyard

func _ready():
	for i in get_children():
		if i is Button:
			i.pressed.connect(button_pressed.bind(i))

func set_button_info(button, gadget):
	button.set_meta("gadget", gadget)
	button.text = GadgetInfo.gadget_roster[gadget]["name"] + "\n Upgrade: $" + str(GadgetInfo.gadget_roster[gadget]["cost"])
	button.show()

func button_pressed(button):
	var gadget = button.get_meta("gadget")
	if CurrentRun.world.current_player_info.current_money >= GadgetInfo.gadget_roster[gadget]["cost"]:
		CurrentRun.world.current_player_info.current_money -= GadgetInfo.gadget_roster[gadget]["cost"]
		CurrentRun.world.update_money_label()
		trainyard.upgrade_gadget(gadget)
