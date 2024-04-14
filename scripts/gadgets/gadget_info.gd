extends Node

var gadget_roster = {
	"pistol_turret" = {
		"name" = "Pistol Turret",
		"scene" = load("res://scenes/gadgets/pistol_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/pistol_turret.png"),
		"cost" = 5,
	},
	"rifle_turret" = {
		"name" = "Rifle Turret",
		"scene" = load("res://scenes/gadgets/rifle_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/rifle_turret.png"),
		"cost" = 10,
	},
	"barricade" = {
		"name" = "Barricade",
		"scene" = load("res://scenes/gadgets/barricade.tscn"),
		"sprite" = load("res://sprites/gadgets/barricade_single.png"),
		"cost" = 2,
	},
	"medical_station" = {
		"name" = "Medical Station",
		"scene" = load("res://scenes/gadgets/medical_station.tscn"),
		"sprite" = load("res://sprites/gadgets/medical_station.png"),
		"cost" = 10,
		"heal_amount" = 1,
	},
}

var selection_active = false
var selected_gadget = null
