extends Node2D

var world = preload("res://scenes/world.tscn")

@onready var escape_menu = $EscapeMenu
@onready var title_screen = $TitleScreen
@onready var restart_screen = $RestartScreen
@onready var black_rect = $EffectsUI/BlackRect

func ready():
	title_screen.show()

func title_screen_start_button_pressed():
	await fade_to_black()
	
	title_screen.hide()
	var new_world = world.instantiate()
	CurrentRun.world = new_world
	CurrentRun.root = self
	add_child(new_world)
	
	fade_in()
	
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
	await fade_to_black()
	
	escape_menu.hide()
	restart_screen.hide()
	CurrentRun.world.queue_free()
	remove_child(CurrentRun.world)
	CurrentRun.world = null
	title_screen.show()
	
	fade_in()

func fade_to_black():
	var fade_tween = create_tween()
	fade_tween.tween_property(black_rect, "modulate", Color.WHITE, .5)
	return fade_tween.finished

func fade_in():
	await get_tree().create_timer(.5).timeout
	var fade_tween = create_tween()
	fade_tween.tween_property(black_rect, "modulate", Color.TRANSPARENT, .5)
	return fade_tween.finished
