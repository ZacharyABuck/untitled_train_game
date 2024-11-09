extends Buff

var stats = {"shock": 0.75}

func bullet_fired(bullet):
	CurrentRun.world.current_level_info.update_attack_stats(bullet.id, stats)
