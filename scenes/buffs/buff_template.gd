extends Node2D
class_name Buff

@export var timed: bool = true
@export var lifetime: float = 3.0

func _ready():
	if "gun_shot" in get_parent():
		get_parent().gun_shot.connect(bullet_fired)
		
	if timed:
		start_lifetimer()

func start_lifetimer():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func bullet_fired(_bullet):
	pass
