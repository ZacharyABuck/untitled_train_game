extends Node2D

@onready var sprite = $AnimatedSprite2D

signal hazard_cleared

func scale_up():
	show()
	var scale_tween = create_tween()
	scale_tween.tween_property(sprite, "scale", Vector2(0.6, sprite.scale.y), 1).set_ease(Tween.EASE_OUT)
	sprite.play("strike")
	await sprite.animation_finished
	sprite.play("recovery")
