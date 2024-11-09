extends Node2D

@onready var zombie_detector = $ZombieDetector

func _on_zombie_detector_area_entered(area):
	if area is HurtboxComponent and area.get_parent() is MeleeEnemy:
		area.get_parent().target = self



func _on_lifetimer_timeout():
	queue_free()
