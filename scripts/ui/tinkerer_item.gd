extends PanelContainer

var gadget: String
@onready var icon = $HBoxContainer/Icon
@onready var name_label = $HBoxContainer/ItemName
@onready var cost_label = $HBoxContainer/Cost


var cost: int

signal clicked

func populate(new_gadget):
	gadget = new_gadget
	
	icon.texture = GadgetInfo.gadget_roster[gadget]["sprite"]
	name_label.text = "[center]" + GadgetInfo.gadget_roster[gadget]["name"]
	
	cost = GadgetInfo.gadget_roster[gadget]["cost"]
	cost_label.text = "[center]Cost: " + str(cost) + "[/center]"

func button_pressed():
	if CurrentRun.world.current_player_info.current_money >= cost:
		CurrentRun.world.current_player_info.current_money -= cost
		CurrentRun.world.update_money_label()
		if CurrentRun.world.current_gadget_info.gadget_inventory.has(gadget):
			CurrentRun.world.current_gadget_info.gadget_inventory[gadget] += 1
		else:
			CurrentRun.world.current_gadget_info.gadget_inventory[gadget] = 1
		queue_free()

