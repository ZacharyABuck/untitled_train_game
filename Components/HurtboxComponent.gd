# Hurtbox Component is just there to connect a Hurtbox (Collision)
# with the Health Component. The Health Component does all the heavy lifting.
# No customization of this component is needed. Just give it a Collision (Hurtbox).

extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent
@export var hurt_sfx: AudioStreamPlayer

func damage(attack: Attack, shooter):
	if health_component:
		health_component.damage(attack, shooter)
		health_component.spawn_particles(health_component.blood_fx)
		for buff in attack.active_buffs:
			health_component.process_buffs(buff)
		play_sfx()

func play_sfx():
	if hurt_sfx and !hurt_sfx.playing:
		hurt_sfx.call_deferred("play")
