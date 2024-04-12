extends Node

var gadget_roster = {
	"pistol_turret" = {
		"name" = "Pistol Turret",
		"scene" = load("res://scenes/gadgets/pistol_turret.tscn"),
		"sprite" = load("res://sprites/gadgets/pistol_turret.png"),
		"cost" = 5,
		"attack_cooldown" = 2,
		"damage" = 2,
	},
	"barricade" = {
		"name" = "Barricade",
		"scene" = load("res://scenes/gadgets/barricade.tscn"),
		"sprite" = load("res://sprites/gadgets/barricade_single.png"),
		"cost" = 2,
		#"health" = 15,
		#"attack_cooldown" = 2,
		#"damage" = 2,
	},
}

var selection_active = false
var selected_gadget = null
