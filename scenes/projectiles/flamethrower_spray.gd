extends Projectile

func _ready():
	super()
	active_buffs.append("fire")
	await get_tree().create_timer(.5).timeout
	$Hitbox/CollisionShape2D.disabled = false

func _on_lifetimer_timeout():
	$GPUParticles2D.emitting = false
	await get_tree().create_timer(5).timeout
	queue_free()
