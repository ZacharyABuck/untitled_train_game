extends Area2D

signal clicked

@onready var name_label = $NameLabel
@onready var animations = $AnimationPlayer

var town_name: String

func _process(delta):
	if WorldInfo.active_town != null:
		if WorldInfo.active_town == town_name:
			animations.play("ring_expand")
			
		else:
			animations.play("fade_out")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()

func set_town_info(town):
	town_name = town
	name_label.text = town_name
