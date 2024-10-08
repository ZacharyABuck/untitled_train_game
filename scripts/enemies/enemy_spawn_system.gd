extends Node2D

@onready var default_spawns = $EnemySpawnPositions/Default
@onready var extra_spawns = $EnemySpawnPositions/Extra

@onready var enemy_wave_timer = $EnemyWaveTimer

var wave_count: int = 2
var spawn_interval: int = 2
var spawning: bool = false
var level

func _ready():
	CurrentRun.world.current_level_info.enemy_spawn_system = self
	level = get_parent()
	await get_tree().create_timer(5).timeout
	spawn_level_enemies()

func _process(delta):
	#set enemy spawn positions to follow train
	if CurrentRun.world.current_train_info.cars_inventory.has(CurrentRun.world.current_train_info.train_stats["car_count"] - 1):
		var node = CurrentRun.world.current_train_info.cars_inventory[CurrentRun.world.current_train_info.train_stats["car_count"] - 1]["node"]
		if node != null:
			global_position = node.global_position
			global_rotation = node.global_rotation

func check_for_enemies():
	if !spawning:
		await get_tree().create_timer(2).timeout
		if level.enemies.get_child_count() == 0:
			spawning = true
			print("All Enemies Dead")
			wave_timer_timeout()
			enemy_wave_timer.start()


func wave_timer_timeout():
	for i in round(wave_count):
		spawn_level_enemies()
		await get_tree().create_timer(spawn_interval).timeout
	CurrentRun.world.current_level_info.difficulty += .05
	wave_count += 1
	spawning = false

func spawn_level_enemies():
	var spawn_count = CurrentRun.world.current_level_info.difficulty
	var new_spawner = EnemySpawner.new()
	add_child(new_spawner)
	new_spawner.wave = true
	
	#spawn enemies by maximum allowed in EnemyInfo
	var random_enemy = new_spawner.find_random_enemy()
	var max_spawn = EnemyInfo.enemy_roster[random_enemy]["max_spawn"]
	new_spawner.spawn_enemy(clamp(spawn_count, 1, max_spawn), random_enemy, null)
	print("Enemies Spawned, Wave: " + str(wave_count) + " Difficulty: " + str(CurrentRun.world.current_level_info.difficulty))
