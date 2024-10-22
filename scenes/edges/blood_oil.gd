extends Edge

var poison_damage: float = 1

func _ready():
	CurrentRun.world.current_player_info.global_poison_damage = 0
	super()

func handle_level_up():
	update_player_info()

func update_player_info():
	CurrentRun.world.current_player_info.global_poison_damage += poison_damage
	print("Increased Global Poison Damage: ", CurrentRun.world.current_player_info.global_poison_damage)
