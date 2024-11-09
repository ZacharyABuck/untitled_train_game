extends Edge

var stats = {"ricochet": 1}

func _ready():
	player.bullet_fired.connect(add_buff_to_attack)
	super()

func handle_level_up():
	stats["ricochet"] += 1

func add_buff_to_attack(id):
	CurrentRun.world.current_level_info.update_attack_stats(id, stats)
