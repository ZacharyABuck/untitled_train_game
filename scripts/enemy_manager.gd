extends Node2D

@onready var enemy_spawn_positions = $"../EnemySpawnPositions"
@onready var train = $"../Train"


var basic_enemy = preload("res://scenes/basic_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_spawn_timer_timeout():
	var new_enemy = basic_enemy.instantiate()
	new_enemy.global_position = enemy_spawn_positions.get_children().pick_random().global_position
	new_enemy.target = train.cars.get_children().pick_random()
	add_child(new_enemy)
