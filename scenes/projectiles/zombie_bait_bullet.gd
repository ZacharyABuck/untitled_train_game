extends Projectile

@onready var zombie_detector = $ZombieDetector
@onready var area_sprite = $AreaSprite
var buffs = {"poison": 1}

func _on_zombie_detector_area_entered(area):
	if area is HurtboxComponent and area.get_parent().type == "melee":
		area.get_parent().target = self
		var new_attack = Attack.new()
		new_attack.attack_damage = damage
		WeaponInfo.attach_buffs(buffs, new_attack.active_buffs)
		area.damage(new_attack, null)

func _on_slowdown_timer_timeout():
	var speed_tween = create_tween()
	speed_tween.tween_property(self, "speed", 0, .5)
	await speed_tween.finished
	var sprite_tween = create_tween()
	sprite_tween.tween_property(area_sprite, "modulate", Color.WHITE, .5)
	
func _on_lifetimer_timeout():
	for enemy in zombie_detector.get_overlapping_bodies():
		if enemy is Enemy and enemy.type == "melee":
			enemy.find_target()
	
	super()
