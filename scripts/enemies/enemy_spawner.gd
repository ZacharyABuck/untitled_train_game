extends Node2D
class_name EnemySpawner

var lifespan: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(lifespan).timeout
	queue_free()

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
			var random_spawn_point_pos = LevelInfo.active_level.enemy_spawn_positions.get_children().pick_random().global_position
			var random_position = Vector2(randf_range(-150,150)+random_spawn_point_pos.x, randf_range(-150,150)+random_spawn_point_pos.y)
			new_enemy.global_position = random_position
		else:
			new_enemy.global_position = pos
		EnemyInfo.enemy_inventory[EnemyInfo.enemy_inventory.keys().size()] = new_enemy
