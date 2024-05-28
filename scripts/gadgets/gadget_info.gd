extends Node

var gadget_roster = {
	"pistol_turret" = {
		"name" = "Pistol Turret",
		"scene" = load("res://scenes/gadgets/gadget_pistol_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_pistol_turret.png"),
		"cost" = 5,
	},
	"barricade" = {
		"name" = "Barricade",
		"scene" = load("res://scenes/gadgets/gadget_barricade.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_barricade_single.png"),
		"cost" = 2,
	},
	"medical_station" = {
		"name" = "Medical Station",
		"scene" = load("res://scenes/gadgets/gadget_medical_station.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_medical_station.png"),
		"cost" = 10,
		"heal_amount" = 1,
	},
}

var turret_upgrade_roster = {
	"rifle_turret" = {
		"name" = "Rifle Turret",
		"scene" = load("res://scenes/gadgets/gadget_rifle_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_rifle_turret.png"),
		"cost" = 10,
	},
	"explosive_turret" = {
		"name" = "Explosive Turret",
		"scene" = load("res://scenes/gadgets/gadget_explosive_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/gadget_explosive_turret.png"),
		"cost" = 10,
	},
}

var selected_gadget = null
