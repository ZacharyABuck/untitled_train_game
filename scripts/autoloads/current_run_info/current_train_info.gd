extends Node2D


var train_manager
var train_engine

var track_positions: Array = []

var cars_inventory = {

}

var train_stats = {
	"car_count": 4,
	"speed": 2.5,
	"car_health": 100,
	"fuel_tank": 25,
}

func clear_variables():
	for car in cars_inventory:
		if cars_inventory[car].keys().has("hard_points"):
			for hard_point in cars_inventory[car]["hard_points"]:
				cars_inventory[car]["hard_points"][hard_point] = null
			cars_inventory[car]["node"] = null
	track_positions.clear()
