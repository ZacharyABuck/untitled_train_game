extends Node2D

@onready var default_spawns = $EnemySpawnPositions/Default
@onready var extra_spawns = $EnemySpawnPositions/Extra

@onready var enemy_wave_timer = $EnemyWaveTimer
@onready var spawn_interval_timer = $SpawnIntervalTimer

var wave_count: int
var spawning: bool = false
var spawn_index: int = 0
var level

func _ready():
	CurrentRun.world.current_level_info.enemy_spawn_system = self
	level = get_parent()
	
	#set wave count to stored valie
	wave_count = CurrentRun.world.current_level_info.wave_count
	
	#spawn first enemies in level
	await get_tree().create_timer(5).timeout
	spawn_level_enemies()
	spawn_interval_timer.start()

func _process(_delta):
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
			
			await get_tree().create_timer(3).timeout

			wave_timer_timeout()

func wave_timer_timeout():
	var label = CurrentRun.world.current_level_info.active_level.alert_label
	label.text = "Wave Spawning!!!"
	label.get_child(0).play("alert_flash")
	label.show()
	spawn_level_enemies()
	spawn_interval_timer.start()
	CurrentRun.world.current_level_info.wave_count = wave_count

func _on_spawn_interval_timer_timeout():
	spawn_index += 1
	
	#finished spawning
	if spawn_index >= wave_count:
		spawn_interval_timer.stop()
		
		CurrentRun.world.current_level_info.difficulty += .03
		wave_count += 1
		enemy_wave_timer.start()
		
		spawn_index = 0
		spawning = false
	#still spawning
	else:

		spawn_level_enemies()
		
		#rng for second enemy to spawn
		var rng = randf_range(1, 5)
		for i in roundf(rng):
			if CurrentRun.world.current_level_info.difficulty >= i:
				spawn_level_enemies()
				print("another enemy spawned")
		
		spawn_interval_timer.start()

func spawn_level_enemies():
	var new_spawner = EnemySpawner.new()
	add_child(new_spawner)
	new_spawner.wave = true
	
	var random_enemy = new_spawner.find_random_enemy()
	new_spawner.spawn_enemy(1, random_enemy, null)
	
	print("Enemies Spawned, Wave: " + str(wave_count) + " Difficulty: " + str(CurrentRun.world.current_level_info.difficulty))
	


