extends Control
class_name Tutorial

@export var dialogue: Array = []
var dialogue_box = preload("res://scenes/ui/tutorials/dialogue_box.tscn")
@export var sfx: AudioStreamPlayer
var dialogue_index: int = 0
var active_dialogue_box
@export var sprite: Texture2D

signal end_tutorial

# Called when the node enters the scene tree for the first time.
func _ready():
	if CurrentRun.world.current_level_info.active_level:
		CurrentRun.world.current_level_info.active_level.pause_game()
	create_dialogue_box()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_dialogue_box():
	#destroy current dialogue box
	if active_dialogue_box:
		active_dialogue_box.queue_free()
	#check if there's more dialogue in the array
	if dialogue_index <= dialogue.size() - 1:
		var new_dialogue = dialogue_box.instantiate()
		add_child(new_dialogue)
		active_dialogue_box = new_dialogue
		new_dialogue.dialogue.text = dialogue[dialogue_index]
		new_dialogue.image.texture = sprite
		new_dialogue.button.pressed.connect(next_dialogue_button_pressed)
		dialogue_index += 1
	#finish dialogue
	else:
		await sfx.finished
		if CurrentRun.world.current_level_info.active_level:
			CurrentRun.world.current_level_info.active_level.unpause_game()
		end_tutorial.emit()
		queue_free()

#when 'next' button is pressed
func next_dialogue_button_pressed():
	if sfx:
		sfx.play()
	create_dialogue_box()
