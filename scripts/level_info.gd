extends Node

var active_level

var root

var active_map

var track_cells = []

var map_positions = []


var level_parameters = {
	"distance" = 5,
	"direction" = "NW",
}

var events = {
	"0" = {
		"distance" = 0,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
	"1" = {
		"distance" = 2,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
	"2" = {
		"distance" = 4,
		"triggered" = false,
		"type" = null,
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
	"stampede" = {
		"scene" = preload("res://scenes/events/event_stampede.tscn"),
	},
}

func clear_variables():
	track_cells.clear()
	map_positions.clear()
	active_map = null
