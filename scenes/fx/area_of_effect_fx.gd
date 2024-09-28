extends Node2D

var damage

# Called when the node enters the scene tree for the first time.
func _ready():
	var particles = $GPUParticles2D
	$ExplodeHitbox/CollisionShape2D.disabled = false
	particles.emitting = true
	$ExplodeSFX.play()
	
	await get_tree().create_timer(.5).timeout
	$ExplodeHitbox/CollisionShape2D.disabled = true


func _on_explode_hitbox_area_entered(area):
	if area is HurtboxComponent:
		var attack = Attack.new()
		attack.attack_damage = damage
		area.damage(attack, null)

func _on_explode_sfx_finished():
	queue_free()
