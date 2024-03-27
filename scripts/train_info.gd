extends Node

var speed = 30

var cars_inventory = {
}

var cars_roster = {
	"engine" = {
		"sprite" = preload("res://sprites/train/engine.png"),
		"hard_points" = ["FrontLeft","FrontRight"],
	},
	"coal" = {
		"sprite" = preload("res://sprites/train/coal_car.png"),
		"hard_points" = ["LeftUpper", "LeftLower", "RightUpper", "RightLower"],
	},
	"lumber" = {
		"sprite" = preload("res://sprites/train/lumber_car.png"),
		"hard_points" = ["LeftUpper", "LeftLower", "RightUpper", "RightLower"],
	},
	"caboose" = {
		"sprite" = preload("res://sprites/train/caboose.png"),
		"hard_points" = ["BackLeft", "BackRight"],
	},
}

var hard_point_icon = preload("res://sprites/train/hard_point_icon.png")
