extends Node

var edge_roster = {
	"fan_the_hammer" = {
		"name" = "Fan the Hammer",
		"category" = "Gunslinger",
		"scene" = load("res://scenes/edges/fan_the_hammer.tscn"),
		"sprite" = load("res://sprites/edges/fan_the_hammer.png"),
		"description" = "Shoot Speed +20%",
		"update" = false,
	},
	"fleet_of_foot" = {
		"name" = "Fleet of Foot",
		"category" = "Survivalist",
		"scene" = load("res://scenes/edges/fleet_of_foot.tscn"),
		"sprite" = load("res://sprites/edges/fleet_of_foot.png"),
		"description" = "Move Speed +20%",
		"update" = false,
	},
	"shadowstep" = {
		"name" = "Shadowstep",
		"category" = "Elsewhere",
		"scene" = load("res://scenes/edges/shadowstep.tscn"),
		"sprite" = load("res://sprites/edges/shadowstep.png"),
		"description" = "Turn to shadows when hit",
		"update" = true,
	},
	"fungal_aura" = {
		"name" = "Fungal Aura",
		"category" = "Elsewhere",
		"scene" = load("res://scenes/edges/fungal_aura.tscn"),
		"sprite" = load("res://sprites/edges/fungal_aura.png"),
		"description" = "Damage surrounding enemies",
		"update" = true,
	},
	"thick_hide" = {
		"name" = "Thick Hide",
		"category" = "Survivalist",
		"scene" = load("res://scenes/edges/thick_hide.tscn"),
		"sprite" = load("res://sprites/edges/thick_hide.png"),
		"description" = "Armor +1",
		"update" = false,
	},
	"cursed_appendage" = {
		"name" = "Cursed Appendage",
		"category" = "Elsewhere",
		"scene" = load("res://scenes/edges/cursed_appendage.tscn"),
		"sprite" = load("res://sprites/edges/cursed_appendage.png"),
		"description" = "Assistance from Beyond",
		"update" = true,
	},
	"ricochet" = {
		"name" = "Ricochet",
		"category" = "Survivalist",
		"scene" = load("res://scenes/edges/ricochet.tscn"),
		"sprite" = load("res://sprites/edges/ricochet.png"),
		"description" = "Bullets bounce",
		"update" = false,
	},
	"mechanic" = {
		"name" = "Mechanic",
		"category" = "Survivalist",
		"scene" = load("res://scenes/edges/mechanic.tscn"),
		"sprite" = load("res://sprites/edges/mechanic.png"),
		"description" = "Repair rate +20%",
		"update" = false,
	},
}

