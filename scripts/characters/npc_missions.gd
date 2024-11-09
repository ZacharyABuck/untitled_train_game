extends NPC

@onready var missions_button = $MissionsButton
@onready var missions_ui = $MissionsUI

var missions_spawned: bool = false
var mission_count: int = 1

func _on_player_detector_body_entered(body):
	if body is Player:
		missions_button.show()

func _on_player_detector_body_exited(body):
	if body is Player:
		missions_button.hide()

func _on_missions_button_pressed():
	AudioSystem.play_audio("basic_button_click", -10)
	missions_ui.show()
	if !missions_spawned:
		missions_spawned = true
		missions_ui.spawn_missions(mission_count)

func _on_close_button_pressed():
	AudioSystem.play_audio("basic_button_click", -10)
	missions_ui.hide()
