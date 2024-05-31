extends Node

var gadget_roster = {
	"pistol_turret" = {
		"name" = "Pistol Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_pistol_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 5,
	},
	"barricade" = {
		"name" = "Barricade",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_barricade.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_barricade_single.png"),
		"cost" = 2,
	},
	"medical_station" = {
		"name" = "Medical Station",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_medical_station.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_medical_station.png"),
		"cost" = 10,
		"heal_amount" = 1,
	},
	"shockwire" = {
		"name" = "Shockwire",
		"location" = "car",
		"scene" = load("res://scenes/gadgets/gadget_shockwire.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_shockwire_icon.png"),
		"cost" = 5,
	},
}

var turret_upgrade_roster = {
	"rifle_turret" = {
		"name" = "Rifle Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 10,
	},
	"explosive_turret" = {
		"name" = "Explosive Turret",
		"location" = "hard_point",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 10,
	},
}

var selected_gadget = null
