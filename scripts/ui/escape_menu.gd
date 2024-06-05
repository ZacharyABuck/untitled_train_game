extends CanvasLayer

@onready var audio_settings = $AudioSettings
@onready var default = $MarginContainer/Default
@onready var are_you_sure_menu = $MarginContainer/AreYouSureMenu




func _on_return_to_game_button_button_up():
	hide()
	owner.unpause_game()

func reset():
	audio_settings.hide()
	are_you_sure_menu.hide()
	
	default.show()
	
func _on_audio_settings_button_button_up():
	default.hide()
	audio_settings.show()


func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

#audio settings back button
func _on_back_button_button_up():
	reset()


func quit_button_button_up():
	default.hide()
	are_you_sure_menu.show()

func _on_yes_button_up():
	owner.get_tree().quit()
