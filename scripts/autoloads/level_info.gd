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
