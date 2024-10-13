extends PanelContainer

var gadget: String
@onready var icon = $HBoxContainer/Icon
@onready var name_label = $HBoxContainer/ItemName
@onready var cost_label = $HBoxContainer/Cost


var unlock_cost: int

signal clicked

func populate(new_gadget):
	gadget = new_gadget
	
	#check if gadget is base level
	if GadgetInfo.gadget_roster[gadget]["name"] == GadgetInfo.gadget_roster[gadget]["base_gadget_name"]:
		name_label.text = "[center]" + GadgetInfo.gadget_roster[gadget]["name"] + "[/center]"
	else:
		name_label.text = "[center]" + GadgetInfo.gadget_roster[gadget]["name"] + "\n(Upgrade from " + GadgetInfo.gadget_roster[gadget]["base_gadget_name"] + ")" + "[/center]"

	
	icon.texture = GadgetInfo.gadget_roster[gadget]["sprite"]
	unlock_cost = GadgetInfo.gadget_roster[gadget]["unlock_cost"]
	cost_label.text = "[right]Unlock: $" + str(unlock_cost) + "[/right]"

func button_pressed():
	if CurrentRun.world.current_player_info.current_money >= unlock_cost:
		CurrentRun.world.current_player_info.current_money -= unlock_cost
		CurrentRun.world.update_money_label()
		GadgetInfo.gadget_roster[gadget]["unlocked"] = true
		
		
		queue_free()

