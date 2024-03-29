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
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("build") and in_game:
		if build_menu_open:
			unpause_game()
			build_menu_open = false
			build_menu.hide()
			for i in PlayerInfo.active_player.active_car.hard_points.get_children():
				var hard_point = i.get_child(0)
				hard_point.animation_player.play("still")
				hard_point.sprite.modulate = Color.WHITE
		else:
			pause_game()
			build_menu_open = true
			build_menu.show()

#this starts a new game
func _on_button_button_down():
	main_menu.hide()
	var new_level = level.instantiate()
	add_child(new_level)
	LevelInfo.active_level = new_level
	LevelInfo.root = self
	in_game = true

func _on_gadget_list_item_clicked(index, _at_position, _mouse_button_index):
	var gadget_info = item_list.get_item_metadata(index)
	if LevelInfo.active_level != null:
		LevelInfo.active_level.request_gadget(gadget_info)

func pause_game():
	LevelInfo.active_level.get_tree().paused = true

func unpause_game():
	LevelInfo.active_level.get_tree().paused = false
