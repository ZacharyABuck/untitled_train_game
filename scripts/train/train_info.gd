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
	"coal" = {
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

var hard_point_icon = preload("res://sprites/train/hard_point_icon.png")

func clear_variables():
	for car in cars_inventory:
		for hard_point in cars_inventory[car]["hard_points"]:
			cars_inventory[car]["hard_points"][hard_point] = null
		cars_inventory[car]["node"] = null
