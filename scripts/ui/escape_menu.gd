extends CanvasLayer

@onready var audio_settings = $AudioSettings
@onready var default = $MarginContainer/Default
@onready var are_you_sure_menu = $MarginContainer/AreYouSureMenu




func _on_return_to_game_button_button_up():
	hide()
	CurrentRun.world.unpause_game()

func reset():
	audio_settings.hide()
	are_you_sure_menu.hide()
	
	default.show()
	
func _on_audio_settings_button_button_up():
	default.hide()
	audio_settings.show()

func _on_volume_slider_value_changed(value):
	var slider = $AudioSettings/VBoxContainer/VolumeSlider
	slider.min_value = 0.0001
	slider.step = 0.0001
	AudioServer.set_bus_volume_db(0, log(value)*20)

#audio settings back button
func _on_back_button_button_up():
	reset()


func quit_button_button_up():
	default.hide()
	are_you_sure_menu.show()

func _on_yes_button_up():
	owner.get_tree().quit()
