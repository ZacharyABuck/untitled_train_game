extends Node2D

@onready var car_spawn_positions = $CarSpawnPositions
var car = preload("res://scenes/train/car.tscn")
@onready var cars = $Cars


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
