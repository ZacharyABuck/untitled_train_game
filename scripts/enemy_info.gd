extends Node

var enemy_types = {
	"gunman" = {
		"scene" = preload("res://scenes/basic_enemy.tscn"),
		"rarity" = 100,
		"damage" = 2,
	},
	"zombie" = {
		"scene" = preload("res://scenes/zombie.tscn"),
		"rarity" = 50,
		"damage" = 1,
	},
}
