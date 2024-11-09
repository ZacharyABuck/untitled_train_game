extends Buff

var stats = {"damage": 1.0}

func bullet_fired(bullet):
	CurrentRun.world.current_level_info.update_attack_stats(bullet.id, stats)
