extends Button

var gadget

func _ready():
	icon = GadgetInfo.gadget_roster[gadget]["sprite"]
