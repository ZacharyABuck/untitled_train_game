extends Node

var gadget_roster = {
	"pistol_turret" = {
		"name" = "Pistol Turret",
		"scene" = preload("res://scenes/pistol_turret.tscn"),
		"sprite" = preload("res://sprites/gadgets/pistol_turret.png"),
		"cost" = 5,
	},
}

var selection_active = false
var selected_gadget = null
