extends CanvasLayer

@onready var town_name_label = %TownNameLabel

@onready var shop_containers = $MarginContainer/PanelContainer/MarginContainer

@onready var jobs = $MarginContainer/PanelContainer/MarginContainer/Jobs
@onready var jobs_container = %JobsContainer
@onready var jobs_button = $MarginContainer/PanelContainer/TownButtons/JobsButton

@onready var trainyard_items_list = %TrainyardItemsList
@onready var trainyard = $MarginContainer/PanelContainer/MarginContainer/Trainyard
@onready var trainyard_button = $MarginContainer/PanelContainer/TownButtons/TrainyardButton

@onready var gunsmith = $MarginContainer/PanelContainer/MarginContainer/Gunsmith
@onready var gunsmith_items_list = %GunsmithItemsList
var gunsmith_items_amount: int = 3
@onready var gunsmith_button = $MarginContainer/PanelContainer/TownButtons/GunsmithButton

@onready var tinkerer = $MarginContainer/PanelContainer/MarginContainer/Tinkerer
@onready var tinkerer_items_list = %TinkererItemsList
var tinkerer_item_amount: int = 5
@onready var tinkerer_button = $MarginContainer/PanelContainer/TownButtons/TinkererButton

var trainyard_item = preload("res://scenes/ui/trainyard_item.tscn")
var gunsmith_item = preload("res://scenes/ui/gunsmith_item.tscn")
var tinkerer_item = preload("res://scenes/ui/tinkerer_item.tscn")
var mission_panel = preload("res://scenes/ui/mission_panel.tscn")

func _ready():
	hide()
	close_all_windows()

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
		if i != jobs_container.get_child(0):
			i.queue_free()
	var max_destination_distance: int = 1500
	for i in count:
		var new_mission = mission_panel.instantiate()
		jobs_container.add_child(new_mission)
		
		new_mission.destination = new_mission.find_random_destination(max_destination_distance)
		max_destination_distance *= 3
		
		new_mission.find_random_mission()
		new_mission.clicked.connect(owner.world_ui.spawn_mission_inventory_panel)

func spawn_trainyard_items():
	for i in trainyard_items_list.get_children():
		if i != trainyard_items_list.get_child(0):
			i.queue_free()
	for i in TrainInfo.train_upgrade_roster.keys():
		var new_item = trainyard_item.instantiate()
		trainyard_items_list.add_child(new_item)
		new_item.populate(i)
		new_item.clicked.connect(owner.upgrade_train)

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

func spawn_tinkerer_items():
	for i in tinkerer_items_list.get_children():
		if i != tinkerer_items_list.get_child(0):
			i.queue_free()
	for i in tinkerer_item_amount:
		var random_gadget = GadgetInfo.upgrade_rosters["default"].pick_random()
		var new_item = tinkerer_item.instantiate()
		tinkerer_items_list.add_child(new_item)
		new_item.populate(random_gadget)
	var new_upgrade_kit = tinkerer_item.instantiate()
	tinkerer_items_list.add_child(new_upgrade_kit)
	new_upgrade_kit.populate("upgrade_kit")

func close_all_windows():
	shop_containers.hide()
	for i in shop_containers.get_children():
		i.hide()

func _on_jobs_button_pressed():
	AudioSystem.play_audio("basic_button_click")
	close_all_windows()
	shop_containers.show()
	jobs.show()

func _on_gunsmith_button_pressed():
	AudioSystem.play_audio("basic_button_click")
	close_all_windows()
	shop_containers.show()
	gunsmith.show()

func _on_tinkerer_button_pressed():
	AudioSystem.play_audio("basic_button_click")
	close_all_windows()
	shop_containers.show()
	tinkerer.show()

func _on_trainyard_button_pressed():
	AudioSystem.play_audio("basic_button_click")
	close_all_windows()
	shop_containers.show()
	trainyard.show()
