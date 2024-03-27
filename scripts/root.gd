extends Node2D

var build_menu_open: bool = false
@onready var build_menu = $BuildMenu


@onready var level = $Level


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("build"):
		if build_menu_open:
			level.get_tree().paused = false
			build_menu_open = false
			build_menu.hide()
			for i in TrainInfo.cars_inventory:
				for h in TrainInfo.cars_inventory[i]["node"].hard_points.get_children():
					h.get_child(0).animation_player.play("still")
		else:
			level.get_tree().paused = true
			build_menu_open = true
			build_menu.show()
			for i in TrainInfo.cars_inventory:
				for h in TrainInfo.cars_inventory[i]["node"].hard_points.get_children():
					h.get_child(0).animation_player.play("still")
			for i in PlayerInfo.active_player.active_car.hard_points.get_children():
				i.get_child(0).animation_player.play("flash")
