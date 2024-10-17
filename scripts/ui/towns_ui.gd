extends CanvasLayer

@onready var town_name_label = %TownNameLabel

@onready var town_screen = $TownScreen
@onready var shop_containers = $TownScreen/PanelContainer/ShopContainers

@onready var jobs = $Jobs
@onready var jobs_container = %JobsContainer
@onready var jobs_button = $TownScreen/PanelContainer/TownButtons/JobsButton

@onready var trainyard = $Trainyard
@onready var trainyard_button = $TownScreen/PanelContainer/TownButtons/TrainyardButton

@onready var gunsmith = $TownScreen/PanelContainer/ShopContainers/Gunsmith
@onready var gunsmith_items_list = %GunsmithItemsList
var gunsmith_items_amount: int = 3
@onready var gunsmith_button = $TownScreen/PanelContainer/TownButtons/GunsmithButton

var trainyard_item = preload("res://scenes/ui/trainyard_item.tscn")
var gunsmith_item = preload("res://scenes/ui/gunsmith_item.tscn")

var mission_panel = preload("res://scenes/ui/mission_panel.tscn")

func _ready():
	hide()
	shop_containers.hide()
	jobs.hide()
	trainyard.hide()
	town_screen.show()
	for i in shop_containers.get_children():
		i.hide()

func populate_town_info(town):
	#active town clicked
	if CurrentRun.world.current_world_info.active_town == town.town_name:
		for i in jobs_container.get_children():
			i.show()
	else:
		for i in jobs_container.get_children():
			i.hide()
	town_name_label.text = "[center]" + town.town_name + "[/center]"
	show()

func _on_close_button_pressed():
	hide()
	close_all_windows()

func spawn_missions(count):
	for i in jobs_container.get_children():
		i.queue_free()
	
	var max_destination_distance: int = 1500
	for i in count:
		var new_mission = mission_panel.instantiate()
		jobs_container.add_child(new_mission)
		
		new_mission.destination = new_mission.find_random_destination(max_destination_distance)
		max_destination_distance *= 3
		
		new_mission.find_random_mission()
		new_mission.clicked.connect(owner.world_ui.spawn_mission_inventory_panel)

func spawn_gunsmith_items():
	for i in gunsmith_items_list.get_children():
		if i != gunsmith_items_list.get_child(0):
			i.queue_free()
	for i in gunsmith_items_amount:
		var random_weapon = WeaponInfo.weapons_roster.keys().pick_random()
		var new_item = gunsmith_item.instantiate()
		gunsmith_items_list.add_child(new_item)
		new_item.populate(random_weapon)
		new_item.clicked.connect(owner.current_player_info.equip_new_weapon)

func close_all_windows():
	AudioSystem.play_audio("basic_button_click", -10)
	trainyard.reset()
	shop_containers.hide()
	jobs.hide()
	trainyard.hide()
	town_screen.show()
	for i in shop_containers.get_children():
		i.hide()

func _on_jobs_button_pressed():
	close_all_windows()
	town_screen.hide()
	jobs.show()

func _on_gunsmith_button_pressed():
	close_all_windows()
	shop_containers.show()
	gunsmith.show()

func _on_trainyard_button_pressed():
	close_all_windows()
	shop_containers.show()
	trainyard.show()
