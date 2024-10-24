extends Projectile

var rotate_speed: float = 500.0

func _physics_process(delta):
	global_position = shooter.global_position
	if animations.animation == "travel":
		rotation_degrees -= rotate_speed * delta

func _on_area_2d_area_entered(area):
	if area is HurtboxComponent and area != last_enemy_hit:
		hit_target.emit(area)
		
		var new_hitbox : HurtboxComponent = area
		var attack = Attack.new()
		
		WeaponInfo.attach_buffs(active_buffs, attack.active_buffs)

		if active_buffs.has("damage"):
			attack.attack_damage = damage * active_buffs["damage"]
		else:
			attack.attack_damage = damage
		
		new_hitbox.damage(attack, shooter)
		if SFX:
			SFX.play()
