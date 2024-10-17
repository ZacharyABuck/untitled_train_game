extends Projectile
class_name ExplodingProjectile

@export var explode_sfx: AudioStreamPlayer
@export var explosion_hitbox: Area2D
@export var splash_damage: int

func _ready():
	super()
	_set_explosion_collisions()
	explosion_hitbox.area_entered.connect(explosion_damage)

#match collisions from hitbox
func _set_explosion_collisions():
	if valid_hitbox_types["enemy"]:
		explosion_hitbox.set_collision_mask_value(4, true)
	if valid_hitbox_types["player"]:
		explosion_hitbox.set_collision_mask_value(1, true)
	if valid_hitbox_types["car"]:
		explosion_hitbox.set_collision_mask_value(3, true)
	if valid_hitbox_types["cover"]:
		explosion_hitbox.set_collision_mask_value(5, true)
	if valid_hitbox_types["terrain"]:
		explosion_hitbox.set_collision_mask_value(9, true)
		pass

#explode if it hits nothing at end of lifetime
func _on_lifetimer_timeout():
	$AnimatedSprite2D.play("hit")

#trigger on hit
func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "hit":
		#play sfx
		if explode_sfx:
			explode_sfx.play()
		#enable explosion hitbox
		if explosion_hitbox:
			explosion_hitbox.set_deferred("monitoring", true)
			explosion_hitbox.set_deferred("monitorable", true)
		
func explosion_damage(area):
	if area is HurtboxComponent and area != last_enemy_hit:
		var new_hitbox : HurtboxComponent = area
		var attack = Attack.new()
		WeaponInfo.attach_buffs(active_buffs, attack.active_buffs)
		attack.attack_damage = splash_damage
		new_hitbox.damage(attack, CurrentRun.world.current_player_info.active_player)
