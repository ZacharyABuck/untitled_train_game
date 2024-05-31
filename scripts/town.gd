extends Area2D

signal clicked

@onready var name_label = $NameLabel



func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()

