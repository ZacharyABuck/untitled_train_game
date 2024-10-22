extends Edge

var fire_damage: float = 1

func _ready():
	CurrentRun.world.current_player_info.global_fire_damage = 0
	super()

func handle_level_up():
	update_player_info()

func update_player_info():
	CurrentRun.world.current_player_info.global_fire_damage += fire_damage
	print("Increased Global Fire Damage: ", CurrentRun.world.current_player_info.global_fire_damage)
