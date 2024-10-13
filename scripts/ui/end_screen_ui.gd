extends CanvasLayer

@onready var margin_container = $MarginContainer
@onready var path_label = $MarginContainer/VBoxContainer/PathLabel
@onready var mission_complete_container = $MarginContainer/VBoxContainer/MissionCompleteContainer
@onready var return_button = $MarginContainer/VBoxContainer/ReturnButton
@onready var no_missions_label = $MarginContainer/VBoxContainer/NoMissionsLabel


var mission_reward_panel = preload("res://scenes/ui/mission_reward_panel.tscn")

func _ready():
	hide()
	return_button.hide()
	no_missions_label.hide()

func fade_in():
	margin_container.position.y = -1000
	show()

	var pos_tween = create_tween()
	pos_tween.tween_property(margin_container, "position", Vector2(0,0), 1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await pos_tween.finished
	
	return_button.show()

func show_no_missions_label():
	no_missions_label.show()

func set_path_label():
	var starting_town = CurrentRun.world.current_world_info.active_town
	var ending_town = CurrentRun.world.current_level_info.destination
	path_label.text = starting_town + " to " + ending_town

func spawn_reward_panel(mission_success, sprite, reward):
	var new_panel = mission_reward_panel.instantiate()
	mission_complete_container.add_child(new_panel)
	new_panel.populate(mission_success, sprite, reward)

func _on_return_button_pressed():
	AudioSystem.play_audio("basic_button_click", -10)
	hide()
	return_button.hide()
	no_missions_label.hide()
