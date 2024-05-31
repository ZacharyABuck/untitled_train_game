extends Edge

var damage = 2
@onready var damage_timer = $DamageTimer
@onready var hitbox = $HitBox


func handle_level_up():
	damage += 1

func _on_damage_timer_timeout():
	damage_enemies()

func damage_enemies():
	for i in hitbox.get_overlapping_areas():
		var new_attack = Attack.new()
		new_attack.attack_damage = damage
		if i is HurtboxComponent and i.get_parent().is_in_group("enemy"):
			i.damage(new_attack)