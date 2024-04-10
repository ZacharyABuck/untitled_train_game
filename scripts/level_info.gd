extends Node

var active_level

var root

var active_map

var track_cells = []

var map_positions = []

var level_parameters = {
	"distance" = 7,
	"direction" = "NW",
}

var events = {
	"0" = {
		"distance" = 1,
		"triggered" = false,
		"type" = "ambush",
		"area" = null,
	},
	"1" = {
		"distance" = 3,
		"triggered" = false,
		"type" = "ambush",
		"area" = null,
	},
}
