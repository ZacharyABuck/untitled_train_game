extends Buff

var stats = {"fire": 0.3}

func bullet_fired(bullet):
	CurrentRun.world.current_level_info.update_attack_stats(bullet.id, stats)
