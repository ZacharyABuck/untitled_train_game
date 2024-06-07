extends Area2D

signal clicked

@onready var name_label = $NameLabel
@onready var animations = $AnimationPlayer

var town_name: String

func _process(_delta):
	if CurrentRun.world.current_world_info.active_town != null:
		if CurrentRun.world.current_world_info.active_town == town_name:
			animations.play("ring_expand")
			
		else:
			animations.play("fade_out")

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()

func set_town_info(town):
	town_name = town
	name_label.text = town_name
