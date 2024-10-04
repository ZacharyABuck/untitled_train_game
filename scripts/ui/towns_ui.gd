extends CanvasLayer

@onready var town_name_label = %TownNameLabel
@onready var town_description = %TownDescription
@onready var town_image = %TownImage

@onready var missions_container = %MissionsContainer
@onready var missions_label = %MissionsLabel
@onready var trainyard_items_list = %TrainyardItemsList

@onready var gunsmith_items_list = %GunsmithItemsList
var gunsmith_items_amount: int = 3

@onready var tinkerer_item_list = %TinkererItemList
var tinkerer_item_amount: int = 5

var trainyard_item = preload("res://scenes/ui/trainyard_item.tscn")
var gunsmith_item = preload("res://scenes/ui/gunsmith_item.tscn")
var tinkerer_item = preload("res://scenes/ui/tinkerer_item.tscn")
var mission_panel = preload("res://scenes/ui/mission_panel.tscn")

func populate_town_info(town):
	#active town clicked
	if CurrentRun.world.current_world_info.active_town == town.town_name:
		for i in missions_container.get_children():
			i.show()
	else:
		for i in missions_container.get_children():
			i.hide()
	town_name_label.text = "[center]" + town.town_name + "[/center]"
	show()

func _on_close_button_pressed():
	hide()

func spawn_missions(count):
	for i in missions_container.get_children():
		if i == missions_label:
			pass
		else:
			i.queue_free()
	for i in count:
		var new_mission = mission_panel.instantiate()
		missions_container.add_child(new_mission)
		new_mission.find_random_mission()
		new_mission.clicked.connect(owner.world_ui.spawn_mission_inventory_panel)

func spawn_trainyard_items():
	for i in trainyard_items_list.get_children():
		i.queue_free()
	for i in TrainInfo.train_upgrade_roster.keys():
		var new_item = trainyard_item.instantiate()
		trainyard_items_list.add_child(new_item)
		new_item.populate(i)
		new_item.clicked.connect(owner.upgrade_train)

func spawn_gunsmith_items():
	for i in gunsmith_items_list.get_children():
		i.queue_free()
	for i in gunsmith_items_amount:
		var random_weapon = WeaponInfo.weapons_roster.keys().pick_random()
		var new_item = gunsmith_item.instantiate()
		gunsmith_items_list.add_child(new_item)
		new_item.populate(random_weapon)
		new_item.clicked.connect(owner.current_player_info.equip_new_weapon)

func spawn_tinkerer_items():
	for i in tinkerer_item_list.get_children():
		i.queue_free()
	for i in tinkerer_item_amount:
		var random_gadget = GadgetInfo.upgrade_rosters["default"].pick_random()
		var new_item = tinkerer_item.instantiate()
		tinkerer_item_list.add_child(new_item)
		new_item.populate(random_gadget)
