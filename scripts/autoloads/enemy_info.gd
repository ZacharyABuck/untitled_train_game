extends Node

var enemy_roster = {
	"bandit" = {
		"scene" = load("res://scenes/enemies/enemy_bandit.tscn"),
		"rarity" = 35,
		"type" = "ranged",
		"health" = 8,
		"damage" = 2.0,
		"money" = 1,
		"speed" = 150,
		"experience" = 3,
		"max_spawn" = 5,
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
		"max_spawn" = 100,
	},
	"big zombie" = {
		"scene" = load("res://scenes/enemies/enemy_big_zombie.tscn"),
		"rarity" = 60,
		"type" = "melee",
		"health" = 40,
		"damage" = 10.0,
		"money" = 5,
		"speed" = 80,
		"experience" = 10,
		"max_spawn" = 1,
	},
	"monstrosity" = {
		"scene" = load("res://scenes/enemies/enemy_monstrosity.tscn"),
		"rarity" = 30,
		"health" = 4,
		"type" = "melee",
		"damage" = 10.0,
		"money" = 1,
		"speed" = 150,
		"experience" = 2,
		"max_spawn" = 3,
	},
}

var elite_modifiers = {
	"damage" = 5.0,
	"health" = 20,
	"speed" = 20,
	"experience" = 5,
	"money" = 2,
}
