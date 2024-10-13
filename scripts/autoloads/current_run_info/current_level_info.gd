extends Node2D


var active_level
var root
var active_map
var track_cells = []
var map_positions = []

var enemy_spawn_system

var destination

var difficulty = 1.0
var wave_count: int = 2

var level_parameters = {
	"distance" = 4,
	"direction" = null,
	"terrain" = null,
}

var events = {
	"0" = {
		"distance" = 1,
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
		"distance" = 3,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
	"3" = {
		"distance" = 4,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
	"4" = {
		"distance" = 5,
		"triggered" = false,
		"type" = null,
		"area" = null,
	},
}

func clear_variables():
	track_cells.clear()
	map_positions.clear()
	active_map = null

var money = preload("res://scenes/drops/money.tscn")

func calculate_random_drop(character):
	spawn_drop(money, character.global_position, character.money)

func spawn_drop(drop, pos, value):
	var new_drop = drop.instantiate()
	new_drop.value = value
	new_drop.global_position = pos
	active_level.call_deferred("add_child", new_drop)
