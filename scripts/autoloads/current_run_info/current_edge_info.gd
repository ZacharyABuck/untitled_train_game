extends Node2D


var selection_active = false
var selected_edge = null

var edge_inventory = {
	#"fan_the_hammer" = {"scene" = load("res://scenes/edges/fan_the_hammer.tscn"), "level" = 1},
	#"fleet_of_foot" = {"scene" = load("res://scenes/edges/fleet_of_foot.tscn"), "level" = 1},
	#"petrichor" = {"scene" = load("res://scenes/edges/petrichor.tscn"), "level" = 1},
	#"elbow_grease" = {"scene" = load("res://scenes/edges/elbow_grease.tscn"), "level" = 1},
}
