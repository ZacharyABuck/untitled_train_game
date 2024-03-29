extends Node

var enemy_roster = {
	"bandit" = {
		"scene" = load("res://scenes/enemies/enemy_bandit.tscn"),
		"rarity" = 1,
		"health" = 5,
		"damage" = 1,
		"money" = 2,
		"speed" = 150,
	},
	"zombie" = {
		"scene" = load("res://scenes/enemies/enemy_zombie.tscn"),
		"rarity" = 50,
		"health" = 10,
		"damage" = 5,
		"money" = 2,
		"speed" = 100,
	},
}

var enemy_inventory = {
	
}
