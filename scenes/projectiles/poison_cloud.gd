extends Node2D

func _ready():
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, .5)
	await fade_tween.finished
	
	queue_free()

func _on_hit_box_area_entered(area):
	if area is HurtboxComponent and area.get_parent() is Enemy:
		var new_attack = Attack.new()
		new_attack.stats["poison"] = 1.0
		area.damage(new_attack)
