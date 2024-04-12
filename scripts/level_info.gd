extends Node

var active_level

var root

var active_map

var track_cells = []

var map_positions = []

var level_parameters = {
	"distance" = 3,
	"direction" = "NW",
}

var events = {
	"0" = {
		"distance" = 1,
		"triggered" = false,
		"type" = "zombie_horde",
		"area" = null,
	},
	"1" = {
		"distance" = 2,
		"triggered" = false,
		"type" = "ambush",
		"area" = null,
	},
}

var events_roster = {
	"ambush" = {
		"scene" = preload("res://scenes/events/event_ambush.tscn"),
	},
	"zombie_horde" = {
		"scene" = preload("res://scenes/events/event_zombie_horde.tscn"),
	},
}

func clear_variables():
	track_cells.clear()
	map_positions.clear()
	active_map = null
