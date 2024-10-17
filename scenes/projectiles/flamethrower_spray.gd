extends Projectile

func _ready():
	super()
	active_buffs["fire"] = true
	await get_tree().create_timer(.5).timeout
	$Hitbox/CollisionShape2D.disabled = false

func _physics_process(_delta):
	if shooter != null:
		global_position = shooter.global_position


func _on_lifetimer_timeout():
	$GPUParticles2D.emitting = false
	await get_tree().create_timer(2).timeout
	$Hitbox/CollisionShape2D.disabled = true
	await get_tree().create_timer(3).timeout
	queue_free()
