extends Node2D


var train_manager
var train_engine
var furnace

var track_positions: Array = []

var cars_inventory = {}

var train_stats = {}

func _ready():
	train_stats = TrainInfo.train_stats
	spawn_cars_inventory()

func clear_variables():
	for car in cars_inventory:
		if cars_inventory[car].keys().has("hard_points"):
			for hard_point in cars_inventory[car]["hard_points"]:
				cars_inventory[car]["hard_points"][hard_point] = null
			cars_inventory[car]["node"] = null
	track_positions.clear()

func spawn_cars_inventory():
	for car in TrainInfo.train_stats["car_count"]:
		cars_inventory[car] = {"node" = null, "type" = null, "hard_points" = {}, "gadgets" = {}, "merc" = null,}

func set_all_gadget_upkeep(value):
	for car in cars_inventory.keys():
		for gadget in cars_inventory[car]["gadgets"]:
			cars_inventory[car]["gadgets"][gadget]["upkeep_paid"] = false
		
