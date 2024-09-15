extends Node

var weapons_roster = {
	"revolver" = {
		"name" = "Revolver",
		"scene" = preload("res://scenes/weapons/revolver_basic.tscn"),
		"sprite" = preload("res://sprites/weapons/revolver.png"),
		"base_attack_delay" = .7,
		"base_projectile_speed" = 1000,
		"base_damage" = 2,
		"base_lifetime" = 3.0,
	},
	
	"rifle" = {
		"name" = "Rifle",
		"scene" = preload("res://scenes/weapons/rifle_basic.tscn"),
		"sprite" = preload("res://sprites/weapons/rifle.png"),
		"base_attack_delay" = 1.5,
		"base_projectile_speed" = 1000,
		"base_damage" = 5,
		"base_lifetime" = 3.0,
	},
	
	"hatchet" = {
		"name" = "Hatchet",
		"scene" = preload("res://scenes/weapons/hatchet.tscn"),
		"sprite" = preload("res://sprites/weapons/hatchet.png"),
		"base_attack_delay" = 1.0,
		"base_projectile_speed" = 400,
		"base_damage" = 4.0,
		"base_lifetime" = 1.0,
	},
	
}
