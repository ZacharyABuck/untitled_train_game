extends Area2D

signal clicked

@onready var name_label = $NameLabel
@onready var town_sprite = $Sprite2D
@onready var shadow = $Shadow
@onready var arrow_sprite = $ArrowSprite
@onready var you_label = $YouLabel
@onready var travel_info = $TravelInfo
@onready var travel_button = $TravelInfo/MarginContainer/VBoxContainer/TravelButton
@onready var gunsmith_icon = $TravelInfo/MarginContainer/VBoxContainer/HBoxContainer/GunsmithIcon
@onready var trainyard_icon = $TravelInfo/MarginContainer/VBoxContainer/HBoxContainer/TrainyardIcon
@onready var tinkerer_icon = $TravelInfo/MarginContainer/VBoxContainer/HBoxContainer/TinkererIcon
@onready var on_screen_notifier = $TravelInfo/MarginContainer/CloseButton/OnScreenNotifier

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
	
	if CurrentRun.world.current_world_info.towns_inventory[town_name].has("gunsmith"):
		gunsmith_icon.show()
	else:
		gunsmith_icon.hide()
	if CurrentRun.world.current_world_info.towns_inventory[town_name].has("tinkerer"):
		tinkerer_icon.show()
	else:
		tinkerer_icon.hide()
	if CurrentRun.world.current_world_info.towns_inventory[town_name].has("trainyard"):
		trainyard_icon.show()
	else:
		trainyard_icon.hide()
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
