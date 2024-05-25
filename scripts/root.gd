extends Node2D

@onready var main_menu = $MainMenu
@onready var level_options = $MainMenu/MarginContainer/LevelOptions


var level = preload("res://scenes/level.tscn")

var in_game = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in level_options.get_children():
		
		var random_terrain = LevelInfo.terrain_roster.keys().pick_random()
		i.text = i.text + "\n(" + LevelInfo.terrain_roster[random_terrain] + ")"
		i.set_meta("terrain", random_terrain)
		i.pressed.connect(level_option_pressed.bind(i))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#this starts a new game
func _on_play_button_down():
	level_options.show()
	$MainMenu/PlayButton.hide()

func level_option_pressed(button):
	start_game(button.name, button.get_meta("terrain"))

func start_game(direction, terrain):
	LevelInfo.clear_variables()
	TrainInfo.clear_variables()
	for i in main_menu.get_children():
		i.hide()
	LevelInfo.level_parameters["direction"] = direction
	LevelInfo.level_parameters["terrain"] = terrain
	print("Terrain Type: " + LevelInfo.terrain_roster[terrain])
	for i in LevelInfo.events.keys():
		LevelInfo.events[i]["type"] = LevelInfo.events_roster.keys().pick_random()
		print("Event " + str(i) + " = " + str(LevelInfo.events[i]["type"]))
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
