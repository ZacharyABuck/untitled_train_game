extends Node2D
class_name Edge

@onready var player = PlayerInfo.active_player
var edge_level: int = 1
var category: String
var edge_name: String
@export var edge_reference: String

func _ready():
	edge_name = EdgeInfo.edge_roster[edge_reference]["name"]
	if EdgeInfo.edge_roster[edge_reference]["update"] == true:
		update_player_info()

func handle_level_up():
	pass

func update_player_info():
	pass
