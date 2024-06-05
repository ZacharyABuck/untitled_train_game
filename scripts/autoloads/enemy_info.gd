extends Node

var enemy_roster = {
	"bandit" = {
		"scene" = load("res://scenes/enemies/enemy_bandit.tscn"),
		"rarity" = 50,
		"type" = "ranged",
		"health" = 5,
		"damage" = 2.0,
		"money" = 1,
		"speed" = 150,
		"experience" = 3,
	},
	"zombie" = {
		"scene" = load("res://scenes/enemies/enemy_zombie.tscn"),
		"rarity" = 1,
		"type" = "melee",
		"health" = 10,
		"damage" = 5.0,
		"money" = 1,
		"speed" = 100,
		"experience" = 3,
	},
	"ghost" = {
		"scene" = load("res://scenes/enemies/enemy_ghost.tscn"),
		"rarity" = 80,
		"health" = 1,
		"type" = "thief",
		"damage" = 0.0,
		"money" = 0,
		"speed" = 200,
		"experience" = 2,
	},
}

var elite_modifiers = {
	"damage" = 5.0,
	"health" = 20,
	"speed" = 20,
	"experience" = 5,
	"money" = 2,
}

var enemy_inventory = {
	
}
