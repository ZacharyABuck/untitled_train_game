extends Node2D

@onready var enemy_spawn_positions = $"../EnemySpawnPositions"
@onready var train = $"../Train"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_spawn_timer_timeout():
	var valid = false
	var random_number = randi_range(1,100)
	var random_enemy
	while valid == false:
		random_enemy = EnemyInfo.enemy_types.keys().pick_random()
		if random_number <= EnemyInfo.enemy_types[random_enemy]["rarity"]:
			valid = true
	var new_enemy = EnemyInfo.enemy_types[random_enemy]["scene"].instantiate()
	new_enemy.global_position = enemy_spawn_positions.get_children().pick_random().global_position
	new_enemy.target = train.cars.get_children().pick_random()
	add_child(new_enemy)
