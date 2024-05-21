extends Node

var active_level

var root

var active_map

var track_cells = []

var map_positions = []

var difficulty = 1
var difficulty_increase_rate = .000025

var level_parameters = {
	"distance" = 6,
	"direction" = "NW",
}

var events = {
	"0" = {
		"distance" = 1,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
	"1" = {
		"distance" = 3,
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
	"shop" = {
		"scene" = preload("res://scenes/events/event_shop.tscn"),
	},
	"haunting" = {
		"scene" = preload("res://scenes/events/event_haunting.tscn"),
	},
}

func clear_variables():
	track_cells.clear()
	map_positions.clear()
	active_map = null


var money = preload("res://scenes/money.tscn")
func spawn_money(pos, amount):
	for i in amount:
		var new_money = money.instantiate()
		new_money.global_position = pos
		active_level.call_deferred("add_child", new_money)
