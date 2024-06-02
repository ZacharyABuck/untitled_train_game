extends PanelContainer

var upgrade: String
@onready var icon = $HBoxContainer/Icon
@onready var name_label = $HBoxContainer/VBoxContainer/ItemName
@onready var cost_label = $HBoxContainer/VBoxContainer/Cost
signal clicked

func populate(new_upgrade):
	upgrade = new_upgrade
	icon.texture = TrainInfo.train_upgrade_roster[new_upgrade]["icon"]
	name_label.text = "[center]" + TrainInfo.train_upgrade_roster[new_upgrade]["name"] + "\n" + "(current: " + str(TrainInfo.train_stats[new_upgrade]) +  ")" + "[/center]"
	
	cost_label.text = "[center]Cost: " + str(TrainInfo.train_upgrade_roster[new_upgrade]["cost"]) + "[/center]"


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if PlayerInfo.current_money >= TrainInfo.train_upgrade_roster[upgrade]["cost"]:
			PlayerInfo.current_money -= TrainInfo.train_upgrade_roster[upgrade]["cost"]
			clicked.emit(upgrade)
			queue_free()
