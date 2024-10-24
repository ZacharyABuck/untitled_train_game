extends Node

var cars_roster = {
	"engine" = {
		"sprite" = preload("res://sprites/train/engine_sketch.png"),
		"possible_hard_points" = ["LeftUpper", "LeftLower", "RightUpper", "RightLower"],
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
		"possible_hard_points" = ["LeftUpper", "LeftLower", "RightUpper", "RightLower"],
	},
}

var train_stats = {
	"car_count": 4,
	"speed": 2.5,
	"car_health": 0,
	"fuel_tank": 8,
}
