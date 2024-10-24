extends Node

var mission_type_roster = {
	"escort" = {
		"name" = "Escort Mission",
		"character" = null,
		"description" = "Refugee looking for transport. I need transport to ",
		"destination" = null,
		"reward" = "merc",
	},
	"delivery" = {
		"name" = "Delivery Mission",
		"character" = null,
		"description" = "Do this delivery for me and maybe you can keep some of the goods. It needs to go to ",
		"destination" = null,
		"icon" = preload("res://sprites/train/crate_icon.png"),
		"reward" = "gadget",
	},
}


