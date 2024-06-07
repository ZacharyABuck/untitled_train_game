extends Node

var speed = 30

var train_manager
var train_engine

var track_positions: Array = []

var cars_inventory = {

}

var cars_roster = {
	"engine" = {
		"sprite" = preload("res://sprites/train/engine.png"),
		"possible_hard_points" = ["FrontLeft","FrontRight"],
	},
	"cargo" = {
		"sprite" = preload("res://sprites/train/coal_car.png"),
		"possible_hard_points" = ["LeftUpper", "LeftLower", "RightUpper", "RightLower"],
	},
	"passenger" = {
		"sprite" = preload("res://sprites/train/lumber_car.png"),
		"possible_hard_points" = ["LeftUpper", "LeftLower", "RightUpper", "RightLower"],
	},
	"caboose" = {
		"sprite" = preload("res://sprites/train/caboose.png"),
		"possible_hard_points" = ["BackLeft", "BackRight"],
	},
}

var train_stats = {
	"car_count": 4,
	"speed": 2.5,
	"car_health": 100,
}

var train_upgrade_roster = {
	"car_count" = {
		"name" = "Purchase Train Car",
		"cost" = 100,
		"icon" = preload("res://sprites/ui/track_single.png"),
		"value" = 1,
	},
	"speed" = {
		"name" = "Upgrade Train Speed",
		"cost" = 50,
		"icon" = preload("res://sprites/ui/track_single.png"),
		"value" = .5,
	},
	"car_health" = {
		"name" = "Upgrade Train Car Health",
		"cost" = 30,
		"icon" = preload("res://sprites/ui/track_single.png"),
		"value" = 30,
	},
}

var hard_point_icon = preload("res://sprites/train/hard_point_icon.png")

func clear_variables():
	for car in cars_inventory:
		if cars_inventory[car].keys().has("hard_points"):
			for hard_point in cars_inventory[car]["hard_points"]:
				cars_inventory[car]["hard_points"][hard_point] = null
			cars_inventory[car]["node"] = null
	track_positions.clear()

