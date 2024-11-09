extends ExplodingProjectile

func explosion_damage(area):
	if area is HurtboxComponent and area != last_enemy_hit:
		var new_hitbox : HurtboxComponent = area
		var attack = Attack.new()
		attack.stats["damage"] = splash_damage
		attack.stats["poison"] = 1.0
		new_hitbox.damage(attack)
