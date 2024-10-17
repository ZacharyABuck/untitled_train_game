extends Node

var mission_type_roster = {
	"escort" = {
		"name" = "Escort Mission",
		"character" = null,
		"description" = "Train engineer for hire. I need transport to ",
		"destination" = null,
		"reward" = 4,
	},
	"delivery" = {
		"name" = "Delivery Mission",
		"character" = null,
		"description" = "I have cargo that needs to go to ",
		"destination" = null,
		"icon" = preload("res://sprites/train/crate_icon.png"),
		"reward" = 4,
	},
}


