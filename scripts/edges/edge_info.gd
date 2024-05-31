extends Node

var selection_active = false
var selected_edge = null


var edge_roster = {
	"fan_the_hammer" = {
		"name" = "[center]Fan the Hammer[/center]",
		"category" = "Gunslinger",
		"scene" = load("res://scenes/edges/fan_the_hammer.tscn"),
		"sprite" = load("res://sprites/edges/fan_the_hammer.png"),
	},
	"fleet_of_foot" = {
		"name" = "[center]Fleet of Foot[/center]",
		"category" = "Survivalist",
		"scene" = load("res://scenes/edges/fleet_of_foot.tscn"),
		"sprite" = load("res://sprites/edges/fleet_of_foot.png"),
	},
	"shadowstep" = {
		"name" = "[center]Shadowstep[/center]",
		"category" = "Elsewhere",
		"scene" = load("res://scenes/edges/shadowstep.tscn"),
		"sprite" = load("res://sprites/edges/shadowstep.png"),
	},
	"fungal_aura" = {
		"name" = "[center]Fungal Aura[/center]",
		"category" = "Elsewhere",
		"scene" = load("res://scenes/edges/fungal_aura.tscn"),
		"sprite" = load("res://sprites/edges/fungal_aura.png"),
	},
}

var edge_inventory = {
	
}
