extends Node2D

var build_menu_open: bool = false
@onready var build_menu = $BuildMenu
@onready var item_list = $BuildMenu/MarginContainer/GadgetList


@onready var main_menu = $MainMenu

var level = preload("res://scenes/level.tscn")

var in_game = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("build") and in_game:
		if build_menu_open:
			LevelInfo.active_level.get_tree().paused = false
			build_menu_open = false
			build_menu.hide()
		else:
			LevelInfo.active_level.get_tree().paused = true
			build_menu_open = true
			build_menu.show()

func _on_button_button_down():
	main_menu.hide()
	var new_level = level.instantiate()
	add_child(new_level)
	LevelInfo.active_level = new_level
	in_game = true

func _on_gadget_list_item_clicked(index, at_position, mouse_button_index):
	var gadget_info = item_list.get_item_metadata(index)
	if LevelInfo.active_level != null:
		LevelInfo.active_level.request_gadget(gadget_info)
