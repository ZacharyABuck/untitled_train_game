extends Node2D

var buffs = {"poison" = true}

func _ready():
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, .5)
	await fade_tween.finished
	
	queue_free()

func _on_hit_box_area_entered(area):
	if area is HurtboxComponent and area.get_parent() is Enemy:
		var new_attack = Attack.new()
		new_attack.attack_damage = 0
		WeaponInfo.attach_buffs(buffs, new_attack.active_buffs)
		area.damage(new_attack, null)
