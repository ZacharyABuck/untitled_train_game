extends CanvasLayer

@onready var town_name_label = %TownNameLabel
@onready var town_description = $MarginContainer/MarginContainer/HBoxContainer/TownDetails/TownDescription
@onready var town_image = $MarginContainer/MarginContainer/HBoxContainer/TownDetails/TownImage
@onready var travel_button = %TravelButton

@onready var missions_container = $MarginContainer/MarginContainer/HBoxContainer/MissionDetails/MarginContainer/MissionsContainer
@onready var missions_label = $MarginContainer/MarginContainer/HBoxContainer/MissionDetails/MarginContainer/MissionsContainer/MissionsLabel
@onready var no_missions_label = $MarginContainer/MarginContainer/HBoxContainer/MissionDetails/MarginContainer/NoMissionsLabel

var mission_panel = preload("res://scenes/ui/mission_panel.tscn")

func populate_town_info(town):
	#active town clicked
	WorldInfo.selected_town = town
	if WorldInfo.active_town == town.town_name:
		no_missions_label.hide()
		%TravelButton.hide()
		if missions_container.get_child_count() > 1:
			pass
		else:
			var mission_count = 3
			for i in mission_count:
				var new_mission = mission_panel.instantiate()
				missions_container.add_child(new_mission)
				new_mission.find_random_mission()
				new_mission.clicked.connect(get_parent().world_ui.spawn_mission_inventory_panel)
	#non active town clicked
	else:
		for i in missions_container.get_children():
			i.queue_free()
		no_missions_label.show()
		%TravelButton.show()
	%TownNameLabel.text = "[center]" + town.town_name + "[/center]"
	show()

func _on_close_button_pressed():
	hide()
