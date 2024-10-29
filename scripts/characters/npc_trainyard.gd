extends NPC

@onready var trainyard_button = $TrainyardButton
@onready var trainyard_canvas = $TrainyardCanvas
@onready var trainyard = $TrainyardCanvas/TrainyardUI

func _on_player_detector_body_entered(body):
	if body is Player:
		trainyard_button.show()

func _on_player_detector_body_exited(body):
	if body is Player:
		trainyard_button.hide()
		trainyard_canvas.hide()

func _on_trainyard_button_pressed():
	trainyard.spawn_trainyard_items()
	trainyard_canvas.show()
