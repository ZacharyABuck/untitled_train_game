extends Node2D

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
		if LevelInfo.active_level.build_menu_open:
			unpause_game()
			LevelInfo.active_level.build_menu_open = false
			LevelInfo.active_level.build_menu.hide()
			for i in TrainInfo.cars_inventory[PlayerInfo.active_player.active_car]["node"].hard_points.get_children():
				var hard_point = i.get_child(0)
				hard_point.animation_player.play("still")
				hard_point.sprite.modulate = Color.WHITE
		else:
			pause_game()
			LevelInfo.active_level.build_menu_open = true
			LevelInfo.active_level.build_menu.show()

#this starts a new game
func _on_button_button_down():
	main_menu.hide()
	var new_level = level.instantiate()
	add_child(new_level)
	LevelInfo.active_level = new_level
	LevelInfo.root = self
	in_game = true

func pause_game():
	LevelInfo.active_level.get_tree().paused = true

func unpause_game():
	LevelInfo.active_level.get_tree().paused = false
