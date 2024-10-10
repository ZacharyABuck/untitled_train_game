extends MeleeEnemy

var area_of_effect = preload("res://scenes/fx/area_of_effect_fx.tscn")

func animation_finished():
	if animations.animation == "boarding":
		explode()

func explode():
	CurrentRun.world.current_level_info.active_level.enemy_killed()
	var new_aoe = area_of_effect.instantiate()
	new_aoe.global_position = global_position
	new_aoe.damage = damage
	CurrentRun.world.current_level_info.active_level.add_child(new_aoe)
	queue_free()
