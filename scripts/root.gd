extends Node2D

var world = preload("res://scenes/world.tscn")

@onready var escape_menu = $EscapeMenu
@onready var title_screen = $TitleScreen
@onready var title_screen_start_button = $TitleScreen/TitleScreenStartButton
@onready var restart_screen = $RestartScreen
@onready var black_rect = $EffectsUI/BlackRect

var tutorials_on: bool = false
@onready var tutorial_ui = $TutorialUI

func ready():
	title_screen.show()

func set_tutorials(value):
	tutorials_on = value
	print(tutorials_on)

func title_screen_start_button_pressed():
	title_screen_start_button.disabled = true
	AudioSystem.play_audio("basic_button_click")
	await fade_to_black(.5)

	title_screen.hide()
	var new_world = world.instantiate()
	CurrentRun.world = new_world
	CurrentRun.root = self
	add_child(new_world)
	
	fade_in()
	
	var camera = CurrentRun.world.camera
	camera.zoom = Vector2(.8,.8)
	var camera_tween = create_tween()
	camera_tween.tween_property(camera, "zoom", Vector2(.6,.6), 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await camera_tween.finished
	tutorial_ui.trigger_tutorial("world_map")
	
func _input(event):
	if event.is_action_pressed("escape_menu"):
		if escape_menu.visible:
			escape_menu.hide()
			escape_menu.reset()
			CurrentRun.world.unpause_game()
		else:
			CurrentRun.world.pause_game()
			escape_menu.show()

func show_restart_button():
	restart_screen.show()
	CurrentRun.world.pause_game()

func restart_button_button_up():
	Input.set_custom_mouse_cursor(null,0,Vector2.ZERO)
	await fade_to_black(.5)
	title_screen_start_button.disabled = false
	escape_menu.hide()
	restart_screen.hide()
	CurrentRun.world.queue_free()
	remove_child(CurrentRun.world)
	CurrentRun.world = null
	title_screen.show()
	
	fade_in()

#EFFECTS FUNCTIONS

func fade_to_black(duration):
	var fade_tween = create_tween()
	fade_tween.tween_property(black_rect, "modulate", Color.WHITE, duration)
	return fade_tween.finished

func fade_in():
	await get_tree().create_timer(.5).timeout
	var fade_tween = create_tween()
	fade_tween.tween_property(black_rect, "modulate", Color.TRANSPARENT, .5)
	return fade_tween.finished
