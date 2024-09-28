extends Area2D

signal clicked

@onready var name_label = $NameLabel
@onready var town_sprite = $Sprite2D
@onready var arrow_sprite = $ArrowSprite
@onready var you_label = $YouLabel


var town_name: String
var town_images: Array = [preload("res://sprites/town/world_map_town_1.png"), preload("res://sprites/town/world_map_town_2.png"), preload("res://sprites/town/world_map_town_3.png")]

func _ready():
	arrow_sprite.hide()
	you_label.hide()
	
	var random_sprite = town_images.pick_random()
	town_sprite.texture = random_sprite

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()
		$ClickedSFX.play()

func set_town_info(town):
	town_name = town
	name_label.text = town_name

func you_are_here():
	arrow_sprite.show()
	you_label.show()

func hide_you_are_here():
	arrow_sprite.hide()
	you_label.hide()

func _on_mouse_entered():
	$HoverAnimation.play("name_bounce")

func _on_mouse_exited():
	$HoverAnimation.play("name_reset", .5)
