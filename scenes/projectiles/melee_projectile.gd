extends Projectile

var rotate_speed: float = 500.0

func _physics_process(delta):
	global_position = CurrentRun.world.current_level_info.attack_inventory[id]["shooter"].global_position
	if animations.animation == "travel":
		rotation_degrees -= rotate_speed * delta

func _on_area_2d_area_entered(area):
	if area is HurtboxComponent and area != last_enemy_hit:
		hit_target.emit(area)
		
		var new_hitbox : HurtboxComponent = area
		var attack = Attack.new()

		attack.stats["damage"] = damage
		
		new_hitbox.damage(attack)
		if SFX:
			SFX.play()
