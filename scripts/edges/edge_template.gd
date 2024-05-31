extends Node2D
class_name Edge

@onready var player = PlayerInfo.active_player
var edge_level: int = 1
var category: String
@export var edge_name: String

func _ready():
	update_player_info()

func handle_level_up():
	pass

func update_player_info():
	pass
