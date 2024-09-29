extends Node

var cars_roster = {
	"engine" = {
		"sprite" = preload("res://sprites/train/lumber_car_sketch.png"),
		"possible_hard_points" = ["FrontLeft","FrontRight"],
	},
	"cargo" = {
		"sprite" = preload("res://sprites/train/lumber_car_sketch.png"),
		"possible_hard_points" = ["LeftUpper", "LeftLower", "RightUpper", "RightLower"],
	},
	"passenger" = {
		"sprite" = preload("res://sprites/train/lumber_car_sketch.png"),
		"possible_hard_points" = ["LeftUpper", "LeftLower", "RightUpper", "RightLower"],
	},
	"caboose" = {
		"sprite" = preload("res://sprites/train/lumber_car_sketch.png"),
		"possible_hard_points" = ["BackLeft", "BackRight"],
	},
}

var train_stats = {
	"car_count": 4,
	"speed": 2.5,
	"car_health": 100,
	"fuel_tank": 25,
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
	"fuel_tank" = {
		"name" = "Upgrade Fuel Tank (travel longer distances)",
		"cost" = 15,
		"icon" = preload("res://sprites/ui/track_single.png"),
		"value" = 10,
	},
}

var hard_point_icon = preload("res://sprites/train/hard_point_icon.png")

