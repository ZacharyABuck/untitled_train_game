extends Node2D
class_name EnemySpawner

var lifespan: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(lifespan).timeout
	queue_free()

func find_random_enemy():
	var valid = false
	var random_enemy
	while valid == false:
		random_enemy = EnemyInfo.enemy_roster.keys().pick_random()
		if EnemyInfo.enemy_roster[random_enemy]["level"] <= CurrentRun.world.current_level_info.difficulty:
			valid = true
			return random_enemy

func find_random_position():
	var random_spawn_point_pos = CurrentRun.world.current_level_info.active_level.enemy_spawn_positions.get_children().pick_random().global_position
	var random_position = Vector2(randf_range(-150,150)+random_spawn_point_pos.x, randf_range(-150,150)+random_spawn_point_pos.y)
	return random_position

func spawn_enemy(amount, type, pos, elite):
	for i in amount:
		var new_enemy = EnemyInfo.enemy_roster[type]["scene"].instantiate()
		if elite:
			new_enemy.elite = true
		CurrentRun.world.current_level_info.active_level.enemies.call_deferred("add_child", new_enemy)
		if pos == null:
			new_enemy.global_position = find_random_position()
		else:
			new_enemy.global_position = pos
		CurrentRun.world.current_enemy_info.enemy_inventory[CurrentRun.world.current_enemy_info.enemy_inventory.keys().size()] = new_enemy
		
		
