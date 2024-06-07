extends Node2D


var active_level
var root
var active_map
var track_cells = []
var map_positions = []

var destination

var difficulty = 1.0

var level_parameters = {
	"distance" = 4,
	"direction" = null,
	"terrain" = null,
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
	"3" = {
		"distance" = 6,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
	"4" = {
		"distance" = 8,
		"triggered" = false,
		"type" = null,
		"area" = null,
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
