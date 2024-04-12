extends Node2D
class_name EnemySpawner

@onready var enemy_spawn_positions = $"../EnemySpawnPositions"

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if PlayerInfo.active_player != null:
		enemy_spawn_positions.global_position = PlayerInfo.active_player.global_position

func find_random_enemy():
	var valid = false
	var random_number = randi_range(1,100)
	var random_enemy
	while valid == false:
		random_enemy = EnemyInfo.enemy_roster.keys().pick_random()
		if EnemyInfo.enemy_roster[random_enemy]["rarity"] <= random_number:
			valid = true
			return random_enemy

func spawn_enemy(amount, type, pos):
	for i in amount:
		var new_enemy = EnemyInfo.enemy_roster[type]["scene"].instantiate()
		LevelInfo.active_level.enemies.call_deferred("add_child", new_enemy)
		if pos == null:
			new_enemy.global_position = enemy_spawn_positions.get_children().pick_random().global_position
		else:
			new_enemy.global_position = pos
		EnemyInfo.enemy_inventory[EnemyInfo.enemy_inventory.keys().size()] = new_enemy
