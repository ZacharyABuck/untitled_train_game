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
func _on_play_button_down():
	$MainMenu/NW.show()
	$MainMenu/NE.show()
	$MainMenu/SW.show()
	$MainMenu/SE.show()
	$MainMenu/PlayButton.hide()

func _on_ne_button_down():
	start_game("NE")

func _on_nw_button_down():
	start_game("NW")

func _on_sw_button_down():
	start_game("SW")

func _on_se_button_down():
	start_game("SE")

func start_game(direction):
	LevelInfo.clear_variables()
	TrainInfo.clear_variables()
	for i in main_menu.get_children():
		i.hide()
	LevelInfo.level_parameters["direction"] = direction
	#for i in LevelInfo.events.keys():
		#LevelInfo.events[i]["type"] = LevelInfo.events_roster.keys().pick_random()
		#print("Event " + str(i) + " = " + str(LevelInfo.events[i]["type"]))
	var new_level = level.instantiate()
	add_child(new_level)
	LevelInfo.active_level = new_level
	unpause_game()
	LevelInfo.root = self
	in_game = true

func pause_game():
	LevelInfo.active_level.get_tree().paused = true

func unpause_game():
	LevelInfo.active_level.get_tree().paused = false

func level_complete():
	pause_game()
	$MainMenu/RestartButton.show()

func _on_restart_button_down():
	PlayerInfo.active_player.queue_free()
	LevelInfo.active_level.queue_free()
	in_game = false
	$MainMenu/RestartButton.hide()
	LevelInfo.active_level = null
	_on_play_button_down()
