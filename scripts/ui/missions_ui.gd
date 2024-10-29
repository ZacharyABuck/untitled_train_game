extends PanelContainer

@onready var vbox = $MarginContainer/VBoxContainer/VBoxContainer
var mission_panel = preload("res://scenes/ui/mission_panel.tscn")

func spawn_missions(count):
	for i in vbox.get_children():
		i.queue_free()
	
	for i in count:
		var new_mission = mission_panel.instantiate()
		vbox.add_child(new_mission)
		
		new_mission.find_random_mission()
		new_mission.clicked.connect(mission_clicked)

func mission_clicked(id):
	CurrentRun.world.world_ui.spawn_mission_inventory_panel(id)
	hide()
	get_parent().missions_button.hide()
