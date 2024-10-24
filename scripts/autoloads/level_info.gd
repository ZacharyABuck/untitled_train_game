extends Node

var terrain_roster: Dictionary = {
	0: "Flooded Land",
	4: "Sands",
	7: "Mesa",
	9: "Canyon",
}

var events_roster = {
	"ambush" = {
		"scene" = preload("res://scenes/events/event_ambush.tscn"),
	},
	"zombie_horde" = {
		"scene" = preload("res://scenes/events/event_zombie_horde.tscn"),
	},
	"stampede" = {
		"scene" = preload("res://scenes/events/event_stampede.tscn"),
	},
	"tentacle_trap" = {
		"scene" = preload("res://scenes/events/event_tentacle_trap.tscn"),
	},
	"level_complete" = {
		"scene" = preload("res://scenes/events/event_level_complete.tscn"),
	},
}

var hazards_roster = {
	"red_barrel" = {
		"scene" = preload("res://scenes/hazards/hazard_red_barrel.tscn"),
	},
	"green_barrel" = {
		"scene" = preload("res://scenes/hazards/hazard_green_barrel.tscn"),
	},
	"blue_barrel" = {
		"scene" = preload("res://scenes/hazards/hazard_blue_barrel.tscn"),
	},
	"spawned_weapon" = {
		"scene" = preload("res://scenes/weapons/spawned_weapon.tscn"),
	},
	"rock_pile" = {
		"scene" = preload("res://scenes/hazards/hazard_rock_pile.tscn"),
	},
	"turret_speed_increase" = {
		"scene" = preload("res://scenes/hazards/hazard_turret_speed_increase.tscn"),
	},
	"turret_poison" = {
		"scene" = preload("res://scenes/hazards/hazard_turret_poison.tscn"),
	},
	"turret_fire" = {
		"scene" = preload("res://scenes/hazards/hazard_turret_fire.tscn"),
	},
	"turret_shock" = {
		"scene" = preload("res://scenes/hazards/hazard_turret_shock.tscn"),
	},
	"furnace_health" = {
		"scene" = preload("res://scenes/hazards/hazard_furnace_health.tscn"),
	},
}
