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
	"spare_bullets" = {
		"name" = "Spare Bullets",
		"category" = "Survivalist",
		"scene" = load("res://scenes/edges/spare_bullets.tscn"),
		"sprite" = load("res://sprites/edges/spare_bullets.png"),
		"description" = "Nearby turrets shoots faster",
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
		"description" = "Furnace Armor +1",
		"update" = true,
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
		"update" = true,
	},
	#"mechanic" = {
		#"name" = "Mechanic",
		#"category" = "Survivalist",
		#"scene" = load("res://scenes/edges/mechanic.tscn"),
		#"sprite" = load("res://sprites/edges/mechanic.png"),
		#"description" = "Repair rate +20%",
		#"update" = false,
	#},
	"petrichor" = {
		"name" = "Petrichor",
		"category" = "Elsewhere",
		"scene" = load("res://scenes/edges/petrichor.tscn"),
		"sprite" = load("res://sprites/edges/petrichor.png"),
		"description" = "Rain heals the furnace",
		"update" = true,
	},
	#"blood_oil" = {
		#"name" = "Blood Oil",
		#"category" = "Survivalist",
		#"scene" = load("res://scenes/edges/blood_oil.tscn"),
		#"sprite" = load("res://sprites/edges/blood_oil.png"),
		#"description" = "Turret Kills Fill Charge",
		#"update" = true,
	#},
	#"seeing_red" = {
		#"name" = "Seeing Red",
		#"category" = "Elsewhere",
		#"scene" = load("res://scenes/edges/seeing_red.tscn"),
		#"sprite" = load("res://sprites/edges/seeing_red.png"),
		#"description" = "Player Kills Fill Charge",
		#"update" = true,
	#},
	"the_voices" = {
		"name" = "The Voices",
		"category" = "Elsewhere",
		"scene" = load("res://scenes/edges/the_voices.tscn"),
		"sprite" = load("res://sprites/edges/the_voices.png"),
		"description" = "Lasso Distance Up 20%",
		"update" = true,
	},
}

