extends NPC
class_name Passenger

var character_name
var car

var enemy_spawn_timer: Timer
var enemy_spawn_interval: float = 30

func _ready():
	super()
	car = get_parent()
	
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.wait_time = enemy_spawn_interval
	enemy_spawn_timer.timeout.connect(spawn_extra_enemies)
	enemy_spawn_timer.start()

func spawn_extra_enemies():
	var new_spawner = EnemySpawner.new()
	var random_enemy = EnemyInfo.enemy_roster.keys().pick_random()
	new_spawner.extra = true
	new_spawner.spawn_enemy(1, random_enemy, null)
