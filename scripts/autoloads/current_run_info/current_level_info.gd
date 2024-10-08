extends Node2D


var active_level
var root
var active_map
var track_cells = []
var map_positions = []

var enemy_spawn_system

var destination

var difficulty = 1.0

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
var scrap = preload("res://scenes/drops/scrap.tscn")

func calculate_random_drop(character):
	var rng = randi_range(-2,10)
	var random_drop
	
	if rng > 0:
		random_drop = money
	else:
		random_drop = scrap
		
	var random_amount = randi_range(-2,1)
	if random_drop == money:
		spawn_drop(money, character.global_position, clamp(character.money+random_amount,0,int(difficulty)))
	elif random_drop == scrap:
		spawn_drop(scrap, character.global_position, 1+random_amount)

func spawn_drop(drop, pos, amount):
	for i in amount:
		var new_drop = drop.instantiate()
		new_drop.global_position = pos
		active_level.call_deferred("add_child", new_drop)
