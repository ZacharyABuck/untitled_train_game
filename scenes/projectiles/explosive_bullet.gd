extends Projectile

@onready var sfx = $ExplodeSFX

func _on_lifetimer_timeout():
	$AnimatedSprite2D.play("hit")


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "hit":
		sfx.play()
		var tween = create_tween()
		tween.tween_property($Area2D/CollisionShape2D, "scale", Vector2(10,10), .5)


