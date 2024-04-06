extends Node2D

@onready var enemy_spawn_positions = $"../EnemySpawnPositions"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if PlayerInfo.active_player != null:
		enemy_spawn_positions.global_position = PlayerInfo.active_player.global_position

func _on_enemy_spawn_timer_timeout():
	var valid = false
	var random_number = randi_range(1,100)
	var random_enemy
	while valid == false:
		random_enemy = EnemyInfo.enemy_roster.keys().pick_random()
		if EnemyInfo.enemy_roster[random_enemy]["rarity"] <= random_number:
			valid = true
	var new_enemy = EnemyInfo.enemy_roster[random_enemy]["scene"].instantiate()
	add_child(new_enemy)
	new_enemy.global_position = enemy_spawn_positions.get_children().pick_random().global_position
	EnemyInfo.enemy_inventory[EnemyInfo.enemy_inventory.keys().size()] = new_enemy
