extends Area2D

signal clicked

@onready var name_label = $NameLabel
@onready var town_sprite = $Sprite2D
@onready var shadow = $Shadow
@onready var collision_shape = $CollisionShape2D
@onready var arrow_sprite = $ArrowSprite
@onready var you_label = $YouLabel
@onready var travel_info = $TravelInfo
@onready var travel_button = $TravelInfo/MarginContainer/VBoxContainer/TravelButton
@onready var on_screen_notifier = $TravelInfo/MarginContainer/CloseButton/OnScreenNotifier
@onready var farthest_town_fx = $FarthestTownFX


var top_pos = -600
var bottom_pos = 200

var town_name: String
var town_images: Array = [preload("res://sprites/town/world_map_town_1.png"), preload("res://sprites/town/world_map_town_2.png"), preload("res://sprites/town/world_map_town_3.png")]

func _ready():
	arrow_sprite.hide()
	you_label.hide()
	
	var random_sprite = town_images.pick_random()
	town_sprite.texture = random_sprite
	shadow.texture = random_sprite
	
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()

func set_town_info(town):
	town_name = town
	name_label.text = town_name
	travel_button.pressed.connect(CurrentRun.world._on_travel_button_pressed)

func show_travel_info():
	CurrentRun.world.current_world_info.selected_town = self
	var fuel_cost = CurrentRun.world.find_fuel_cost()
	if fuel_cost > CurrentRun.world.current_train_info.train_stats["fuel_tank"]:
		travel_button.text = "Too Far!"
	else:
		travel_button.text = "All Aboard!"
	
	CurrentRun.world.show_travel_line(town_name)
	travel_info.show()
	
	await get_tree().create_timer(.05).timeout
	
	if on_screen_notifier.is_on_screen():
		pass
	else:
		travel_info.position.y = bottom_pos
	
func hide_travel_info():
	travel_info.hide()
	CurrentRun.world.travel_line.hide()

func you_are_here():
	arrow_sprite.show()
	you_label.show()

func hide_you_are_here():
	arrow_sprite.hide()
	you_label.hide()

func _on_mouse_entered():
	$HoverAnimation.play("name_bounce")
	AudioSystem.play_audio("tick", -10)

func _on_mouse_exited():
	$HoverAnimation.play("name_reset", .5)

func _on_close_button_pressed():
	hide_travel_info()

func check_warnings():
	check_mercs()
	check_maintenance()

func hide_warnings():
	$WarningInfo.hide()

func check_mercs():
	for merc in CurrentRun.world.current_character_info.mercs_inventory.keys():
		var car_index = 0
		for car in CurrentRun.world.current_train_info.cars_inventory.keys():
			if CurrentRun.world.current_train_info.cars_inventory[car]["merc"] == merc:
				break
			else:
				car_index += 1
				if car_index == CurrentRun.world.current_train_info.cars_inventory.keys().size():
					$WarningInfo.show()
					$WarningInfo/MarginContainer/VBoxContainer/MercAvailable.show()
				else:
					$WarningInfo.hide()
					$WarningInfo/MarginContainer/VBoxContainer/MercAvailable.hide()

func check_maintenance():
	for car in CurrentRun.world.current_train_info.cars_inventory.keys():
		for gadget in CurrentRun.world.current_train_info.cars_inventory[car]["gadgets"].keys():
			if CurrentRun.world.current_train_info.cars_inventory[car]["gadgets"][gadget]["upkeep_paid"] == false:
				$WarningInfo.show()
				$WarningInfo/MarginContainer/VBoxContainer/MaintenanceNeeded.show()
				return
			else:
				$WarningInfo.hide()
				$WarningInfo/MarginContainer/VBoxContainer/MaintenanceNeeded.hide()
